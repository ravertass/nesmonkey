;;;;;;;; Game logic ;;;;;;;;
;; All game logic goes here.
;; Graphics and input logic does NOT go here.

    .include "logic/entities.asm"
    .include "logic/entity.asm"
    .include "logic/entity_space.asm"
    .include "logic/monkey.asm"
    .include "logic/boomerang.asm"
    .include "logic/follow_movement_lut.asm"
    .include "logic/seagull.asm"
    .include "logic/teeth.asm"
    .include "logic/minimize_vector.asm"
    .include "logic/collision.asm"
    .include "logic/water_collision.asm"
    .include "logic/follow.asm"
    .include "logic/new_seagull.asm"
    .include "logic/new_teeth.asm"
    .include "logic/new_enemies.asm"
    .include "util/random.asm"

UpdateGame:
    IncrementPointer16 gameClock
    JSR GenerateEnemies
    JSR UpdateEntities

    RTS
