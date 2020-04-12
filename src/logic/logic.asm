;;;;;;;; Game logic ;;;;;;;;
;; All game logic goes here.
;; Graphics and input logic does NOT go here.

    .include "logic/boomerang.asm"
    .include "logic/monkey.asm"
    .include "logic/entity.asm"
    .include "logic/entity_space.asm"
    .include "util/random.asm"

UpdateGame:
    ; set pointer to first entity in the entity list.
    LDA #LOW(firstEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(firstEntity)
    STA currentEntity,Y

.UpdateEntitiesLoop:
    ; if entity is not active: continue to next entity.
    LDY #entityActive
    LDA [currentEntity],Y
    BEQ .NextEntity

    LDY #entityType
    LDA [currentEntity],Y
    CMP #TYPE_MONKEY
    BEQ .JsrUpdateMonkey

    LDY #entityType
    LDA [currentEntity],Y
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
    LDA currentEntity
    CLC
    ADC #entitySize
    STA currentEntity
    LDY #$01
    LDA currentEntity,Y
    ADC #$00 ; add carry to high byte of pointer
    STA currentEntity,Y

    ; if we have looped through all entities: break loop.
    ; we must check both the low and the high byte of the currentEntity pointer.
    LDA currentEntity
    CMP #LOW(endOfEntitySpace)
    BEQ .CompareHigh
    JMP .UpdateEntitiesLoop
.CompareHigh:
    ; the lower byte was equal: let's check if the higher byte is equal, too.
    LDY #$01
    LDA currentEntity,Y
    CMP #HIGH(endOfEntitySpace)
    BEQ .UpdateEntitiesDone
    JMP .UpdateEntitiesLoop

.UpdateEntitiesDone:
    RTS
