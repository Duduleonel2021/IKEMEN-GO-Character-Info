-- CHARACTER INFO - SHARED SFF
-- IKEMEN GO v1.0.0-rc.3
--
-- All character cards are stored in ONE SFF:
-- external/mods/character_info.sff
--
-- Add characters by registering their SFF group and sprite index
-- in charIndex.
-- No characters folder is required.

local cis = {
    key = 'x',
    sffPath = 'external/mods/character_info.sff',

    panel = {
        width = 330,
        height = 450,
        y = 145,
        margin = 35,
    },

    open = {false, false},
    ref = {nil, nil},
    char = {nil, nil},
    anim = {nil, nil},
}

-- Character identifier -> SFF group and sprite index.
--
-- The identifier is the filename of the character .def, without ".def".
-- The folder structure is ignored.
--
-- Format:
--   character = {GROUP, INDEX}
--
-- The module accepts any valid SFF GROUP and INDEX combination.
--
-- All cards are stored in:
-- external/mods/character_info.sff

local charIndex = {
    kfm = {0, 1},
}

local sharedSff = nil

if fileExists(cis.sffPath) then
    sharedSff = sffNew(cis.sffPath)
end

local function localcoord()
    if motif
        and motif.info
        and motif.info.localcoord
        and motif.info.localcoord[1]
        and motif.info.localcoord[2]
    then
        return motif.info.localcoord[1], motif.info.localcoord[2]
    end

    return 1280, 720
end

local function panelX(side)
    local w = localcoord()

    if side == 1 then
        return cis.panel.margin
    end

    return w - cis.panel.margin - cis.panel.width
end

local function getSelectedRef(player)
    if player == nil then
        return nil
    end

    if start.c[player] == nil then
        return nil
    end

    return start.c[player].selRef
end

local function getCharacterName(ref)
    if ref == nil then
        return nil
    end

    local cd = start.f_getCharData(ref)

    if cd == nil then
        return nil
    end

    local raw = cd.char or cd.def

    if raw == nil then
        return nil
    end

    raw = tostring(raw)
    raw = raw:gsub('\\', '/')

    local filename = raw:match('([^/]+)$') or raw
    local char = filename:gsub('%.def$', ''):lower()

    return char
end

local function clearSkin(side)
    cis.anim[side] = nil
    cis.char[side] = nil
end

local function loadSkin(side, player)
    clearSkin(side)

    if sharedSff == nil then
        return false
    end

    local ref = getSelectedRef(player)

    if ref == nil then
        return false
    end

    local char = getCharacterName(ref)

    if char == nil or char == '' or char == 'randomselect' then
        return false
    end

    local mapping = charIndex[char]

    if mapping == nil then
        return false
    end

    local group = mapping[1]
    local index = mapping[2]

    if group == nil or index == nil then
        return false
    end

    local animDef =
        tostring(group)
        .. ','
        .. tostring(index)
        .. ', 0,0, -1'

    local anim = animNew(sharedSff, animDef)

    if anim == nil then
        return false
    end

    local w, h = localcoord()

    animSetLocalcoord(anim, w, h)
    animSetScale(anim, 1, 1)
    animSetLayerno(anim, 2)
    animSetFacing(anim, 1)
    animSetWindow(anim, 0, 0, w, h)

    animSetPos(
        anim,
        panelX(side),
        cis.panel.y
    )

    animUpdate(anim, true)

    cis.ref[side] = ref
    cis.char[side] = char
    cis.anim[side] = anim

    return true
end

local function openInfo(side, player)
    if loadSkin(side, player) then
        cis.open[side] = true
    end
end

local function closeInfo(side)
    cis.open[side] = false
    cis.ref[side] = nil
    clearSkin(side)
end

local originalSelectMenu = start.f_selectMenu

local function infoPressed(cmd, player)
    if cmd ~= nil then
        local ok, result = pcall(getInput, cmd, cis.key)

        if ok and result then
            return true
        end
    end

    if player ~= nil then
        local ok, result = pcall(getInput, player, cis.key)

        if ok and result then
            return true
        end
    end

    return false
end

start.f_selectMenu = function(side, cmd, player, member, selectState)

    if cis.open[side] then

        if infoPressed(cmd, player) then
            closeInfo(side)
            return selectState, false
        end

        if cmd ~= nil
            and motif
            and motif.select_info
            and motif.select_info.cancel
        then
            local ok, result = pcall(
                getInput,
                cmd,
                motif.select_info.cancel.key
            )

            if ok and result then
                closeInfo(side)
                return selectState, false
            end
        end

        return selectState, false
    end

    if infoPressed(cmd, player) then
        openInfo(side, player)
        return selectState, false
    end

    return originalSelectMenu(
        side,
        cmd,
        player,
        member,
        selectState
    )
end

local function drawInfo(side)
    if not cis.open[side] then
        return
    end

    local anim = cis.anim[side]

    if anim == nil then
        return
    end

    local w, h = localcoord()

    animSetLocalcoord(anim, w, h)
    animSetWindow(anim, 0, 0, w, h)
    animSetLayerno(anim, 2)

    animSetPos(
        anim,
        panelX(side),
        cis.panel.y
    )

    animUpdate(anim, true)
    animDraw(anim, 2)
end

hook.add(
    'start.f_selectScreen',
    'characterInfoSFF',
    function()
        drawInfo(1)
        drawInfo(2)
    end
)

hook.add(
    'start.f_selectReset',
    'characterInfoSFFReset',
    function()
        closeInfo(1)
        closeInfo(2)
    end
)
