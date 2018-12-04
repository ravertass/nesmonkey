;;;;;;;; New seagull ;;;;;;;;
;; Subroutines for adding a new seagull to entity space.

NewSeagull:
    JSR GetFreeEntitySlot
    LDA #HIGH(currentEntity)
    CMP #$FF
    BEQ .NewSeagullDone ; no free entity slot was found :(

    LDA #$01
    LDY #entityActive
    STA [currentEntity],Y

    LDA #TYPE_SEAGULL
    LDY #entityType
    STA [currentEntity],Y

    ; TODO: Most of the stuff below is just copied from the monkey.

    JSR RandomByte
    LDY #entityX
    STA [currentEntity],Y
    JSR RandomByte
    LDY #entityY
    STA [currentEntity],Y
    JSR RandomByte
    LDY #entityX
    INY
    STA [currentEntity],Y
    JSR RandomByte
    LDY #entityY
    INY
    STA [currentEntity],Y

    LDA #$04
    LDY #entityDX
    STA [currentEntity],Y
    LDA #$01
    LDY #entityDY
    STA [currentEntity],Y

    LDA #DIR_RIGHT
    LDY #entityDir
    STA [currentEntity],Y

    LDA #MOVING
    LDY #entityState
    STA [currentEntity],Y

    LDA #$00
    LDY #entityAnimationFrame
    STA [currentEntity],Y

    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y

    LDA #$08
    LDY #entityAnimationMax
    STA [currentEntity],Y

    LDA #LOW(seagullAnimationsTable)
    LDY #entityAnimationsTable
    STA [currentEntity],Y
    LDA #HIGH(seagullAnimationsTable)
    INY
    STA [currentEntity],Y

.NewSeagullDone
    RTS
