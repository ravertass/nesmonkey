;;;;;;;; Graphics logic -- Entities ;;;;;;;;
;; Logic related to drawing entities goes here.

UpdateMonkeySprites:
    LDA #LOW(monkeyEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(monkeyEntity)
    STA currentEntity,Y

    JMP .UpdateEntitySprites

.UpdateEntitySprites:
    LDY #entityAnimationsTable
    LDA [currentEntity],Y
    STA currentAnimationsTable

    INY
    LDA [currentEntity],Y
    LDY #$01
    STA currentAnimationsTable,Y


    LDY #entityDir
    LDA [currentEntity],Y
    CMP #DIR_UP
    BEQ .SetEntitySpritesUp

    LDY #entityDir
    LDA [currentEntity],Y
    CMP #DIR_DOWN
    BEQ .SetEntitySpritesDown

    LDY #entityDir
    LDA [currentEntity],Y
    CMP #DIR_LEFT
    BEQ .SetEntitySpritesLeft

    LDY #entityDir
    LDA [currentEntity],Y
    CMP #DIR_RIGHT
    BEQ .SetEntitySpritesRight

.EntitySpritesSet:
    JSR AnimateEntitySprites
    RTS

.SetEntitySpritesUp:
    LDY #entityState
    LDA [currentEntity],Y
    CMP #IDLE
    BEQ .SetEntitySpritesUpIdle
    ; Else: monkeyState == #MOVING
.SetEntitySpritesUpMoving:
    LDY #animationsUpMoving
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet
.SetEntitySpritesUpIdle:
    LDY #animationsUpIdle
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet

.SetEntitySpritesDown:
    LDY #entityState
    LDA [currentEntity],Y
    CMP #IDLE
    BEQ .SetEntitySpritesDownIdle
    ; Else: monkeyState == #MOVING
.SetEntitySpritesDownMoving:
    LDY #animationsDownMoving
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet
.SetEntitySpritesDownIdle:
    LDY #animationsDownIdle
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet

.SetEntitySpritesLeft:
    LDY #entityState
    LDA [currentEntity],Y
    CMP #IDLE
    BEQ .SetEntitySpritesLeftIdle
    ; Else: monkeyState == #MOVING
.SetEntitySpritesLeftMoving:
    LDY #animationsLeftMoving
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet
.SetEntitySpritesLeftIdle:
    LDY #animationsLeftIdle
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet

.SetEntitySpritesRight:
    LDY #entityState
    LDA [currentEntity],Y
    CMP #IDLE
    BEQ .SetEntitySpritesRightIdle
    ; Else: monkeyState == #MOVING
.SetEntitySpritesRightMoving:
    LDY #animationsRightMoving
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet
.SetEntitySpritesRightIdle:
    LDY #animationsRightIdle
    JSR .SetMetaSpritePointer
    JMP .EntitySpritesSet


; SUBROUTINE
; Input:
;     Reg Y: Animations table offset (e.g. #animationsRightIdle)
.SetMetaSpritePointer:
    LDA [currentAnimationsTable],Y
    STA currentMetaSpritePointer

    INY
    LDA [currentAnimationsTable],Y
    LDY #$01
    STA currentMetaSpritePointer,Y

    RTS
