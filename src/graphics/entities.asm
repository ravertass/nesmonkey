;;;;;;;; Graphics logic -- Entities ;;;;;;;;
;; Logic related to drawing entities goes here.

; SUBROUTINE
; Input:
;     currentEntity: The entity we're working with.
; Clobbers:
;     Reg A, ?Reg X?, Reg Y
; Side-effects:
;     Draws currentEntity's current sprite to the screen.
UpdateEntitySprites:
    ReadMember16ToP entityAnimationsTable, currentAnimationsTable

    ReadMemberToA entityDir
    CMP #DIR_UP
    BEQ .SetEntitySpritesUp

    ReadMemberToA entityDir
    CMP #DIR_DOWN
    BEQ .SetEntitySpritesDown

    ReadMemberToA entityDir
    CMP #DIR_LEFT
    BEQ .SetEntitySpritesLeft

    ReadMemberToA entityDir
    CMP #DIR_RIGHT
    BEQ .SetEntitySpritesRight

.EntitySpritesSet:
    JSR AnimateEntitySprites
    RTS

.SetEntitySpritesUp:
    ReadMemberToA entityState
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
    ReadMemberToA entityState
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
    ReadMemberToA entityState
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
    ReadMemberToA entityState
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
;     currentEntity: The entity we're working with.
;     currentAnimationsTable: The animations table under use right now.
;     Reg Y: Animations table offset (e.g. #animationsRightIdle)
; Output:
;     currentMetaSpritePointer: Pointer to the meta sprite in the animations table that we want.
;     currentEntity.entityAnimationLength: The number of frames in the current animation.
.SetMetaSpritePointer:
    LDA [currentAnimationsTable],Y
    STA currentMetaSpritePointer

    INY
    LDA [currentAnimationsTable],Y
    LDY #$01
    STA currentMetaSpritePointer,Y

    JMP .SetCurrentAnimationLength

.SetCurrentAnimationLength:
    ; Animation is at least of length 1
    WriteMember entityAnimationLength, #$01
    LDY #$FF
    JMP .SetCurrentAnimationLengthLoop
.SetCurrentAnimationLengthIncrement:
    IncrementMember entityAnimationLength
.SetCurrentAnimationLengthLoop:
    INY
    LDA [currentMetaSpritePointer],Y
    CMP #$FE
    BEQ .SetCurrentAnimationLengthIncrement ; Another frame found!
    CMP #$FF
    BNE .SetCurrentAnimationLengthLoop
    ; We've looped through the whole animation

    RTS
