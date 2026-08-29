-- ============================================================
-- CHARACTER INFO - SFF PER CHARACTER
-- IKEMEN GO v1.0.0-rc.3
-- ============================================================
--
-- FUNÇÃO:
--   No Select Character, deixe o cursor sobre o personagem e
--   pressione X.
--
--   O módulo identifica o personagem selecionado e abre:
--
--     external/mods/characters/<char>/<char>-info.sff
--
--   Exemplo:
--
--     KFM -> characters/kfm/kfm-info.sff
--     RYU -> characters/ryu/ryu-info.sff
--     KEN -> characters/ken/ken-info.sff
--
-- O SFF contém TODA a ficha visual em um único sprite.
-- Não existe leitura de character_info.def.
-- Não existe texto desenhado pelo Lua.
--
-- X abre.
-- X fecha.
--
-- A ficha é desenhada em LAYER 2.
--
-- A lógica de entrada é baseada diretamente na versão anterior
-- funcional do módulo: start.f_selectMenu.
-- ============================================================

local cis = {
    key = 'x',

    -- Geometria do painel (mesmos valores da versão anterior
    -- funcional), usada para posicionar a ficha na tela.
    panel = {
        width = 330,
        height = 450,
        y = 145,
        margin = 35,
    },

    open = {
        false,
        false,
    },

    ref = {
        nil,
        nil,
    },

    char = {
        nil,
        nil,
    },

    sff = {
        nil,
        nil,
    },

    anim = {
        nil,
        nil,
    },
}

-- ============================================================
-- LOCALCOORD
-- ============================================================

local function localcoord()
    if motif
        and motif.info
        and motif.info.localcoord
        and motif.info.localcoord[1]
        and motif.info.localcoord[2]
    then
        return
            motif.info.localcoord[1],
            motif.info.localcoord[2]
    end

    return 1280, 720
end

-- Calcula a posição X do painel: P1 fica com margem na
-- esquerda, P2 fica com margem na direita (espelhado).
local function panelX(side)
    local w = localcoord()

    if side == 1 then
        return cis.panel.margin
    end

    return w - cis.panel.margin - cis.panel.width
end

-- ============================================================
-- GET CHARACTER DATA
-- ============================================================

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

    if cd.char == nil then
        return nil
    end

    return tostring(cd.char):lower()
end

-- ============================================================
-- LOAD SFF
-- ============================================================

local function clearSkin(side)
    cis.sff[side] = nil
    cis.anim[side] = nil
    cis.char[side] = nil
end

local function loadSkin(side, player)
    clearSkin(side)

    local ref =
        getSelectedRef(player)

    if ref == nil then
        return false
    end

    local char =
        getCharacterName(ref)

    if char == nil
        or char == ''
        or char == 'randomselect'
    then
        return false
    end

    local path =
        'external/mods/characters/'
        .. char
        .. '/'
        .. char
        .. '-info.sff'

    -- Use the same file-existence mechanism used by the
    -- current IKEMEN GO source.
    if main
        and main.f_fileExists
        and not main.f_fileExists(path)
    then
        return false
    end

    local sff =
        sffNew(path)

    if sff == nil then
        return false
    end

    -- One single sprite: group 0 / index 0.
    local anim =
        animNew(
            sff,
            '0,0, 0,0, -1'
        )

    if anim == nil then
        return false
    end

    local w, h =
        localcoord()

    animSetLocalcoord(
        anim,
        w,
        h
    )

    animSetScale(
        anim,
        1,
        1
    )

    -- IMPORTANT:
    -- The character information must be in front of the
    -- character select portraits.
    animSetLayerno(
        anim,
        2
    )

    animSetFacing(
        anim,
        1
    )

    animSetPos(
        anim,
        panelX(side),
        cis.panel.y
    )

    animUpdate(anim)

    cis.ref[side] = ref
    cis.char[side] = char
    cis.sff[side] = sff
    cis.anim[side] = anim

    return true
end

-- ============================================================
-- OPEN / CLOSE
-- ============================================================

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

-- ============================================================
-- INPUT
-- ============================================================
--
-- O IKEMEN chama:
--
-- start.f_selectMenu(
--     side,
--     v.cmd,
--     v.player,
--     member,
--     v.selectState
-- )
--
-- Portanto, o primeiro argumento depois de side é o COMMAND
-- do jogador. A versão anterior usava player em getInput();
-- aqui aceitamos os dois formatos para manter compatibilidade.
-- ============================================================

local originalSelectMenu =
    start.f_selectMenu

local function infoPressed(cmd, player)
    -- Forma correta para o fluxo atual do Select Screen.
    if cmd ~= nil
        and getInput(
            cmd,
            cis.key
        )
    then
        return true
    end

    -- Compatibilidade com a implementação anterior funcional.
    if player ~= nil
        and getInput(
            player,
            cis.key
        )
    then
        return true
    end

    return false
end

start.f_selectMenu =
    function(
        side,
        cmd,
        player,
        member,
        selectState
    )
        -- Ficha aberta: X fecha e bloqueia a seleção naquele frame.
        if cis.open[side] then
            if infoPressed(cmd, player)
                or getInput(
                    cmd,
                    motif.select_info.cancel.key
                )
            then
                closeInfo(side)
            end

            return selectState, false
        end

        -- Ficha fechada: X abre.
        if infoPressed(cmd, player) then
            openInfo(
                side,
                player
            )

            return selectState, false
        end

        -- Qualquer outro comando continua exatamente com
        -- o Select Character original.
        return originalSelectMenu(
            side,
            cmd,
            player,
            member,
            selectState
        )
    end

-- ============================================================
-- DRAW
-- ============================================================

local function drawInfo(side)
    if not cis.open[side] then
        return
    end

    local anim =
        cis.anim[side]

    if anim == nil then
        return
    end

    -- O sprite já contém o layout completo.
    -- Não existe painel Lua, texto Lua ou portrait Lua.
    animSetLayerno(
        anim,
        2
    )

    animSetPos(
        anim,
        panelX(side),
        cis.panel.y
    )

    animUpdate(anim)

    animDraw(
        anim,
        2
    )
end

-- start.f_selectScreen chama este hook todos os frames.
hook.add(
    'start.f_selectScreen',
    'characterInfoSFF',
    function()
        drawInfo(1)
        drawInfo(2)
    end
)

-- ============================================================
-- RESET
-- ============================================================

hook.add(
    'start.f_selectReset',
    'characterInfoSFFReset',
    function()
        closeInfo(1)
        closeInfo(2)
    end
)
