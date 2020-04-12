;;;;;;;; Game logic ;;;;;;;;
;; All game logic goes here.
;; Graphics and input logic does NOT go here.

    .include "logic/boomerang.asm"
    .include "logic/monkey.asm"
    .include "logic/entity.asm"
    .include "logic/entity_space.asm"
    .include "util/random.asm"

UpdateGame:
    LoadEntity firstEntity

.UpdateEntitiesLoop:
    ; if entity is not active: continue to next entity.
    ReadMemberToA entityActive
    BEQ .NextEntity

    ReadMemberToA entityType
    CMP #TYPE_MONKEY
    BEQ .JsrUpdateMonkey

    ReadMemberToA entityType
    CMP #TYPE_BOOMERANG
    BEQ .JsrUpdateBoomerang

    ; If this entity's type has no logic implemented, simply do the general update.
    JMP .GeneralEntityUpdate

.JsrUpdateMonkey:
    JSR UpdateMonkey
    JMP .GeneralEntityUpdate

.JsrUpdateBoomerang:
    JSR UpdateBoomerang
    JMP .GeneralEntityUpdate

.GeneralEntityUpdate:
    ; General update for entities goes here.
    ; UpdateEntityMoving handles X and Y movement according
    ; to DX and DY, and updating the animationCount value.
    JSR UpdateEntityMoving


.NextEntity:
    ; increment currentEntity pointer so we point to the next entity.
    AddToPointer16 currentEntity, #entitySize

    ; if we have looped through all entities: break loop.
    ; we must check both the low and the high byte of the currentEntity pointer.
    ComparePointer16 currentEntity, endOfEntitySpace
    BEQ .UpdateEntitiesDone
    JMP .UpdateEntitiesLoop

.UpdateEntitiesDone:
    RTS
