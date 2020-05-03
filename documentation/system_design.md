# System design

**NOTE**: This document is not up-to-date, and will possibly never be again.
Its purpose has mainly been to practice technical writing.

This document outlines the system design for the game, describing architecture, source file structure, data structures, algorithms, memory structure, and more.

## Source code file structure

The `src` directory contains the following subdirectories:

- `content`
- `graphics`
- `input`
- `logic`
- `util`

In addition, the directory contains a few asm files:

- **main.asm** -- Main file. Contains all top-level code.
- **header.asm** -- Contains assembler directives defining memory properties (e.g. what mapper to use).
- **general\_setup.asm** -- Contains general setup that you'd typically want done in any NES game.

The code in `header.asm` and `general_setup.asm` should be pretty generic and reusable for other games (for the header, this depends on what memory properties the game needs).
A lot of the code in `main.asm` should be pretty generic, too, but many parts (such as RAM variables) would not be directly reusable within another NES game.

### content

The `content` directory contains graphics-related content. It contains the following files:

- **monkey.chr** -- All graphics in a binary format readable by YY-CHR, which can be directly imported into memory via assembly.
- **background.asm** -- All graphics data for drawing the background (except for palettes) (with references to the memory where the graphics reside).
- **sprites.asm** -- All graphics data for sprites (except for palettes) (with references to the memory where the graphics reside), including animations.
- **palette.asm** -- Palette data for background and sprites.

Note that none of these asm files contain any actual logic, just data.

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

### util

The `util` directory contains logic that is useful in certain contexts. It contains a single file:

- **random.asm** -- Contains a subroutine for generating a random byte.

All code in this directory should also be generic enough to be reusable within other NES games (even if they do not follow a very similar architecture).

### logic

All code within the `logic` directory is for directly game-related logic. It contains the following files:

-  **logic.asm** -- Contains the *UpdateGame* subroutine called each vblank, which loops through each entity in entity space and calls its related update subroutine, as well as a general entity update subroutine.
-  **entity.asm** -- Contains general entity updating logic (which right now only is movement-related).
-  **monkey.asm** -- Contains logic for the main character (the monkey). Reads the latest controller input and updates the monkey's state accordingly.
-  **new\_seagull.asm** -- Adds a new seagull entity to the entity space, choosing properties for it randomly.
-  **entity\_space.asm** -- Logic for getting a free slot within entity space.
-  **setup.asm** -- Sets up game logic (monkey, entity space and random seed (which probably should be done elsewhere, to make `util` more generic)).
-  **setup\_entity\_space.asm** -- Fills entity space with only 0's.
-  **setup\_monkey.asm** -- Sets up the monkey entity with initial values.

The `logic` directory is not really generic.
The entity concept should be reusable within other NES games using a similar architecture, but the entities themselves are not directly reusable.

## Entities and entity space

**TODO** -- Write about the entity concept, the entity data structure, the structure of entity space.
Any "physical" thing appearing in the game is represented as an *entity*.
Examples of entities are the player avatar (i.e. the monkey), enemies, the monkey's boomerang, and banana pickups.

The same data structure is used for each entity.
The *entity space* is the area of memory containing all entities.
Further explanation follows.

### Entity data structure

The entity data structure contains the following fields:

- entityActive (1 byte)
- entityType (1 byte)
- entityX (2 byte)
- entityY (2 byte)
- entityDX (2 byte)
- entityDY (2 byte)
- entityDir (1 byte)
- entityState (1 byte)
- entityAnimationCount (1 byte)
- entityAnimationMax (1 byte)
- entityAnimationFrame (1 byte)
- entityAnimationLength (1 byte)
- entityOverridePalette (1 byte)
- entityAnimationsTable (2 byte)
- entitySize (1 byte)

Details follow.

#### entityActive

Is equal to `$00` if this entity's location in entity space is not active.
If the entity is active, then this is equal to `$01`.

#### entityType

Describes what this entity is, e.g. the monkey, a seagull enemy, or a banana pickup.
Each type of entity has a corresponding constant value, and this field will be set to one of these type constants.

#### entityX

**TODO**

#### entityY

**TODO**

#### entityDX

**TODO**

#### entityDY

**TODO**

#### entityDir

**TODO**

#### entityState

**TODO**

#### entityAnimationCount

**TODO**

#### entityAnimationMax

**TODO**

#### entityAnimationFrame

**TODO**

#### entityAnimationLength

**TODO**

#### entityOverridePalette

**TODO**

#### entityAnimationsTable

**TODO**

#### entitySize

**TODO**

### Accessing an entity field

If `currentEntity` (and `currentEntity+1`) contains a pointer to an entity, then the 1-byte field `entityField` is accessed like this:

```
    LDY #entityField
    LDA [currentEntity],Y
```

For example, `entityActive` would be accessed like this:

```
    LDY #entityActive
    LDA [currentEntity],Y
```

A 2-byte field, such as `entityX` or `entityDX`, would have to be accessed 1 byte at a time.
An example of how `entityX` is updated using `entityDX` follows:


```
    ; Add lower DX to lower X byte
    LDY #entityX
    LDA [currentEntity],Y
    CLC
    LDY #entityDX
    ADC [currentEntity],Y
    LDY #entityX
    STA [currentEntity],Y

    ; Add higher DX with carry to higher X byte
    LDY #entityX
    INY
    LDA [currentEntity],Y
    LDY #entityDX
    INY
    ADC [currentEntity],Y
    LDY #entityX
    INY
    STA [currentEntity],Y
```

### Entity space

**TODO**

## Sprites and animation

An entity's sprite data comes in the form of an *animation table*.
An animation table consists of *animations*, which in turn each consists of a number of *frames*, also called *metasprites*.
A *metasprite* consists of multiple *sprites*, and a *sprite* (the data structure representing the data to draw NES sprites) consists of four bytes in the following order:

- y offset
- tile number (referring to the graphics tileset `monkey.chr`)
- attribute byte
- x offset

Further explanation follows.

### Animation tables

An animation table is a list of animations, in the form of memory locations (symbols) for the animations.
Each animation table has the following form:

```
foobarAnimationsTable:
    .dw sprFoobarUpIdle,   sprFoobarDownIdle,   sprFoobarLeftIdle,   sprFoobarRightIdle
    .dw sprFoobarUpMoving, sprFoobarDownMoving, sprFoobarLeftMoving, sprFoobarRightMoving
```

Each animation corresponds to a "state" (e.g. idle turned left).
All animation tables must contain animations for each state, in the same order.
However, if some state is not applicable for an entity, the animation table might simply contain references to an empty animation (one such animation called `dummySprites` can be found in the code).

### Animations & metasprites

An animation is a list of frames/metasprites.
Metasprites consist of sprites, and sprites are four bytes long.
The sprite bytes of a metasprite follow directly on each other in memory.
A metasprite may consist of 0 to *a large number* of sprites.
The end of a metasprite is denoted by an `$FE` byte (mnemonic: can be read as "frame end") (meaning that `$FE` could never be the y offset of a sprite).
A metasprite could also end with an `$FF` byte, which also indicates the end of the whole animation (meaning that `$FF` also cannot be the y offset of a sprite).
An example follows:

```
sprFoobarDownMoving:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $15, %00000000, $00
    ; Lower sprite
    .db $08, $25, %00000000, $00
    ; End of animation frame
    .db $FE
    ; Upper sprite
    .db $00, $15, %01000000, $00
    ; Lower sprite
    .db $08, $25, %01000000, $00
    ; End of animation
    .db $FF
```

Since NES sprites are only 8x8 pixels, to draw larger objects, multiple sprites must be used.
This is the purpose of metasprites.

### Sprites

As mentioned above, the sprite data structure consists of four bytes in the following order: *y offset*, *tile number*, *attribute byte* and *x offset*.

X and Y offsets are the pixel offset from the entity's current X and Y coordinates.
For sprites to not overlap, these will typically be a number divisible by 8.

The tile number is where the sprite data (the actual pixel data for the sprite) can be found in the tileset (`content/monkey.chr` for this game).

The attribute byte contains bits for a few different properties.
The attribute byte has the following form:

```
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Not used
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically
```

An example sprite follows:

```
    .db $08, $15, %10000000, $00
```

Here, `$08` is the y offset (indicating that the sprite is located one "step" down), `$15` is the location of the sprite data in the tileset, `%10000000` is the attribute byte (indicating that this sprite is flipped vertically) and `$00` is the x offset.

## Game update

**TODO** -- Write about entity updating and anything else game-related done each vblank.

## Coding guidelines

**TODO**

### Macros

**TODO** -- Naming, usage, comments.

### Subroutines

**TODO** -- Naming, usage, comments.

### Loops

**TODO** -- Naming of labels, how to generally do loops (both with registers and RAM variables).

### Conditionals

**TODO** -- Naming of labels, how to generally write different types of conditionals.

## Memory structure

**TODO** -- A map drawing the memory structure (zero page, etc.).
