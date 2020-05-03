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
    EReadMember16ToP entityAnimationsTable, currentAnimationsTable

    EReadMemberToA entityDir
    CMP #DIR_UP
    BEQ .SetEntitySpritesUp

    EReadMemberToA entityDir
    CMP #DIR_DOWN
    BEQ .SetEntitySpritesDown

    EReadMemberToA entityDir
    CMP #DIR_LEFT
    BEQ .SetEntitySpritesLeft

    EReadMemberToA entityDir
    CMP #DIR_RIGHT
    BEQ .SetEntitySpritesRight

.EntitySpritesSet:
    JSR AnimateEntitySprites
    RTS

.SetEntitySpritesUp:
    ECheckFlag #FLAG_IS_MOVING
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
    ECheckFlag #FLAG_IS_MOVING
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
    ECheckFlag #FLAG_IS_MOVING
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
    ECheckFlag #FLAG_IS_MOVING
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
    STA currentMetaSpritePointer+1

    JMP .SetCurrentAnimationLength

.SetCurrentAnimationLength:
    EWriteMember entityAnimationLength, #$00
    LDY #$FF
    JMP .SetCurrentAnimationLengthLoop
.SetCurrentAnimationLengthIncrement:
    STY currentMetaSpriteOffset
    EIncrementMember entityAnimationLength
    LDY currentMetaSpriteOffset
.SetCurrentAnimationLengthLoop:
    INY
    LDA [currentMetaSpritePointer],Y
    CMP #$FE
    BEQ .SetCurrentAnimationLengthIncrement ; Another frame found!
    CMP #$FF
    BNE .SetCurrentAnimationLengthLoop
    ; We've looped through the whole animation

    RTS
