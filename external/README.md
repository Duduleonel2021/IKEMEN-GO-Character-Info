# IKEMEN GO - Character Info

[English](#english) | [Português](#português)

---

# English

## Character Info

**Character Info** is a custom module for **IKEMEN GO** that displays a visual information card for the currently selected character directly on the Character Select screen.

When the cursor is positioned over a character, pressing **X** opens that character's information card.

Instead of generating the information dynamically from the character's `.def` file, each character can have its own `.sff` file containing the complete visual layout.

This makes the system simple, flexible and highly customizable.

---

## Features

- Displays character information directly from the Character Select screen.
- Uses the **X** button to open the information card.
- Supports **Player 1 and Player 2**.
- Uses a single SFF sprite as the complete information card.
- Each character can have its own information SFF.
- The visual design is completely controlled by the SFF image.
- Does not depend on character information being rendered from the `.def` file.
- Allows different visual designs for characters from different games.
- The information card is displayed at **layer 2**, keeping it above the character selection artwork.

---

## How it works

The module identifies the character currently selected by the cursor.

When the player presses **X**, Character Info looks for an information SFF associated with that character.

For example:

```text
characters/
├── kfm/
│   ├── kfm.def
│   └── kfm-info.sff
│
├── ryu/
│   ├── ryu.def
│   └── ryu-info.sff
│
└── ken/
    ├── ken.def
    └── ken-info.sff
```

If the cursor is over KFM:

```text
X
↓
kfm-info.sff
↓
Character information card appears
```

If the cursor is over Ryu:

```text
X
↓
ryu-info.sff
↓
Ryu information card appears
```

---

## Information Card

The information card is a **single SFF sprite**.

All visual elements can be created directly in the image:

- Character portrait
- Character name
- Fighting style
- Franchise
- Original game
- Country
- Height
- Weight
- Difficulty
- Special moves
- Icons
- Decorative elements
- Background
- Borders
- Labels
- Additional information

The module does not need to create these visual elements dynamically.

**The SFF is the visual design.**

This makes it possible to create completely different information cards for different games while keeping the same module.

---

## File Naming

The information SFF follows the character's folder and name.

Example:

```text
kfm/kfm-info.sff
ryu/ryu-info.sff
ken/ken-info.sff
akuma/akuma-info.sff
```

The expected format is:

```text
<character-name>-info.sff
```

The filename must correspond to the character definition used by IKEMEN GO.

---

## Installation

Place the module in:

```text
external/mods/
```

The main module file is:

```text
external/mods/character_info.lua
```

Character information SFF files should remain inside their respective character folders.

Example:

```text
external/
└── mods/
    ├── character_info.lua
    │
    └── characters/
        ├── kfm/
        │   ├── kfm.def
        │   └── kfm-info.sff
        │
        ├── ryu/
        │   ├── ryu.def
        │   └── ryu-info.sff
        │
        └── ken/
            ├── ken.def
            └── ken-info.sff
```

---

## Creating a Character Information Card

Create the visual card using your preferred image editor.

Recommended workflow:

1. Create the information card artwork.
2. Export the final image.
3. Convert/import the image into SFF.
4. Use a single sprite for the complete card.
5. Save the SFF using the character's name followed by `-info`.

Example:

```text
ryu-info.sff
```

The module will display the entire sprite as the information card.

---

## Important

The SFF does **not** need multiple layers or multiple sprites for the information fields.

A character information card can be represented by a single sprite:

```text
ryu-info.sff
└── Single Sprite
    └── Complete Character Information Card
```

This is intentional.

The goal is to make the visual design independent from Lua.

---

## Controls

### Character Select

Position the cursor over a character and press:

```text
X
```

The character information card will appear.

Press:

```text
X
```

again to close the card.

---

## Compatibility

Designed for:

**IKEMEN GO**

The module was developed and tested during the project using IKEMEN GO.

---

## Customization

The major advantage of this system is that the visual design is not restricted by Lua text rendering.

For example, one game can use:

```text
Cyberpunk Information Card
```

while another can use:

```text
Retro Arcade Information Card
```

and another can use:

```text
Modern Fighting Game Information Card
```

All of them can use the same Character Info module.

Only the character's SFF needs to change.

---

## Credits

Developed for the IKEMEN GO community.

Special thanks to the IKEMEN GO developers and community for making the engine and its Lua customization capabilities possible.

---

# Português

## Character Info

O **Character Info** é um módulo personalizado para **IKEMEN GO** que exibe um card visual com informações do personagem diretamente na tela de seleção.

Quando o cursor está sobre um personagem, basta pressionar **X** para abrir o card de informações.

Em vez de gerar os dados dinamicamente a partir do arquivo `.def`, cada personagem pode possuir seu próprio arquivo `.sff` contendo todo o layout visual.

Isso torna o sistema simples, flexível e altamente personalizável.

---

## Recursos

- Exibe informações diretamente na tela de seleção de personagens.
- Utiliza o botão **X** para abrir o card.
- Funciona para **Player 1 e Player 2**.
- Utiliza um único sprite SFF como card completo.
- Cada personagem pode possuir seu próprio SFF.
- O visual é totalmente controlado pelo SFF.
- Não depende da renderização das informações do personagem a partir do arquivo `.def`.
- Permite diferentes estilos visuais para personagens de jogos diferentes.
- O card é exibido em **layer 2**, permanecendo à frente da arte da tela de seleção.

---

## Como funciona

O módulo identifica o personagem que está atualmente selecionado pelo cursor.

Quando o jogador pressiona **X**, o Character Info procura o SFF correspondente ao personagem.

Por exemplo:

```text
characters/
├── kfm/
│   ├── kfm.def
│   └── kfm-info.sff
│
├── ryu/
│   ├── ryu.def
│   └── ryu-info.sff
│
└── ken/
    ├── ken.def
    └── ken-info.sff
```

Se o cursor estiver sobre KFM:

```text
X
↓
kfm-info.sff
↓
Card de informações aparece
```

Se estiver sobre Ryu:

```text
X
↓
ryu-info.sff
↓
Card de informações aparece
```

---

## Card de informações

O card é formado por **um único sprite SFF**.

Todos os elementos visuais podem ser criados diretamente na imagem:

- Retrato
- Nome
- Estilo de luta
- Franquia
- Jogo original
- País
- Altura
- Peso
- Dificuldade
- Golpes especiais
- Ícones
- Elementos decorativos
- Fundo
- Bordas
- Rótulos
- Outras informações

O módulo não precisa criar esses elementos visualmente.

**O SFF é o próprio design.**

Isso permite criar cards completamente diferentes para jogos diferentes utilizando o mesmo módulo.

---

## Nome dos arquivos

O SFF de informações segue o nome do personagem.

Exemplo:

```text
kfm/kfm-info.sff
ryu/ryu-info.sff
ken/ken-info.sff
akuma/akuma-info.sff
```

O formato utilizado é:

```text
<nome-do-personagem>-info.sff
```

---

## Instalação

Coloque o módulo em:

```text
external/mods/
```

O arquivo principal é:

```text
external/mods/character_info.lua
```

Os arquivos SFF devem permanecer dentro das respectivas pastas dos personagens.

Exemplo:

```text
external/
└── mods/
    ├── character_info.lua
    │
    └── characters/
        ├── kfm/
        │   ├── kfm.def
        │   └── kfm-info.sff
        │
        ├── ryu/
        │   ├── ryu.def
        │   └── ryu-info.sff
        │
        └── ken/
            ├── ken.def
            └── ken-info.sff
```

---

## Criando um card

Crie o card no seu editor de imagens preferido.

Fluxo recomendado:

1. Crie o layout visual.
2. Exporte a imagem final.
3. Converta/importe a imagem para SFF.
4. Utilize um único sprite para o card completo.
5. Salve usando o nome do personagem seguido de `-info`.

Exemplo:

```text
ryu-info.sff
```

O módulo exibirá o sprite inteiro como card de informações.

---

## Importante

O SFF **não precisa possuir vários sprites ou camadas** para representar cada informação.

Um card pode ser simplesmente:

```text
ryu-info.sff
└── Um único Sprite
    └── Card completo de informações
```

Essa é uma característica intencional do projeto.

A ideia é deixar o **visual completamente independente do Lua**.

---

## Controles

### Tela de seleção de personagens

Posicione o cursor sobre o personagem e pressione:

```text
X
```

O card será exibido.

Pressione:

```text
X
```

novamente para fechar o card.

---

## Compatibilidade

Desenvolvido para:

**IKEMEN GO**

O módulo foi desenvolvido e testado durante o projeto utilizando o IKEMEN GO.

---

## Personalização

A principal vantagem desse sistema é que o visual não fica limitado às possibilidades de renderização de texto do Lua.

Um jogo pode utilizar:

```text
Cyberpunk Information Card
```

Outro:

```text
Retro Arcade Information Card
```

E outro:

```text
Modern Fighting Game Information Card
```

Todos podem utilizar o mesmo módulo.

Apenas o SFF de cada personagem precisa ser alterado.

---

## Créditos

Desenvolvido para a comunidade IKEMEN GO.

Agradecimentos aos desenvolvedores e à comunidade do IKEMEN GO por disponibilizarem o engine e suas possibilidades de personalização através de Lua.
