# IKEMEN-GO Character Info

A character information module for **IKEMEN GO** that displays an individual character information card directly on the character select screen.

The module was designed to work with a **single shared SFF file**, making character management simpler and avoiding the need to create a separate folder and SFF file for every character.

---

## Features

- Displays a character information card on the character select screen.
- Supports Player 1 and Player 2 independently.
- Uses a single shared SFF file for all character cards.
- Identifies characters automatically from their `.def` filename.
- Folder structure does not matter.
- Uses a simple character-to-sprite index mapping.
- Card is opened and closed using a configurable keyboard key.
- Supports the default `X` key.
- Does not require modifications to individual character files.
- Does not require a dedicated character information folder.
- Automatically resets when the character select screen is reset.

---

# How It Works

The module consists of two main files:

```text
external/
└── mods/
    ├── character_info.lua
    └── character_info.sff
