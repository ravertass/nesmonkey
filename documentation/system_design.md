# System design

This document outlines the system design of the game.

## Source code file structure

The `src` directory contains the following subdirectories:

- content
- graphics
- input
- logic
- util

In addition, the directory contains a few asm files:

- **main.asm** -- Main file. Contains basically everything.
- **header.asm** -- Contains assembler directives defining memory properties.
- **general\_setup.asm** -- Contains general setup subroutines that you'd typically want done in any NES game.

The code in `header.asm` and `general_setup.asm` should be pretty generic and reusable for other games (for the header, this depends on what memory properties the game needs).
A lot of the code in `main.asm` should be pretty generic, too, but many parts (such as RAM variables) would not be directly reusable within another NES game.

### content

The `content` directory contains graphics-related content. It contains the following files:

- **monkey.chr** -- All graphics in a binary format readable by YY-CHR, and which can be directly imported into the assembly memory.
- **background.asm** -- All graphics data for drawing the background (except for palettes).
- **sprites.asm** -- All graphics data for sprites (except for palettes), including animations.
- **palette.asm** -- Palette data for background and sprites.

Note that none of these ASM files contain any actual logic, just data.

For more information on the animation data format, see [Sprites and animation](#sprites-and-animation).

### graphics

The `graphics` directory contains logic for drawing graphics. It contains the following files:

- **setup.asm** -- Sets up graphics drawing, including the palette.
- **setup\_background.asm** -- Draw the background (which must only be done once in the beginning, since the background doesn't change).
- **graphics.asm** -- Logic for drawing sprites each frame. Loops through each entity within the entity space and draws its current animation frame.
- **entities.asm** -- Logic for drawing an entity.
- **animations.asm** -- Logic for drawing an entity's animation.

The idea is that all code within the `graphics` directory should be generic enough to be reusable within other NES games with a similar architecture.

### input

The `input` directory contains logic for reading controller input. It contains a single file:

- **input\_logic.asm** -- Contains logic for reading Controller 1's input.

As with the `graphics` directory, the `input` logic is supposed to be reusable within other NES games.

## util

The `util` directory contains logic that is useful in certain contexts. It contains a single file:

- **random.asm** -- Contains a subroutine for generating a random byte.

All code in this directory should also be generic enough to be reusable within other NES games (even if they do not follow a very similar architecture).

### logic

All files within the `logic` directory contains game-related logic. It contains the following files:

-  **logic.asm** -- Contains the UpdateGame subroutine called each vblank, which loops through each entity in entity space and calls its related update-subroutine, as well as general entity update.
-  **entity.asm** -- Contains general entity updating logic, that is, movement-related logic.
-  **monkey.asm** -- Contains logic for the main character (the monkey), reading the latest controller input and updating the monkey's state accordingly.
-  **new\_seagull.asm** -- Adds a new seagull entity to the entity space, choosing properties for it randomly.
-  **entity\_space.asm** -- Logic for getting a free slot within entity space.
-  **setup.asm** -- Sets up game logic (monkey, entity space and random seed (which probably should be done elsewhere)).
-  **setup\_entity\_space.asm** -- Fills entity space with only 0's.
-  **setup\_monkey.asm** -- Sets up the monkey entity with initial values.

The `logic` directory is not really generic.
Entity logic should be reusable within other NES games using a similar architecture, but the entities themselves are not directly reusable.

## Entities and entity space

**TODO**

## Sprites and animation

**TODO**

## Coding guidelines

**TODO**

### Macros

**TODO**

### Subroutines

**TODO**

### Loops

**TODO**

### Jumps

**TODO**

## Memory structure

**TODO**
