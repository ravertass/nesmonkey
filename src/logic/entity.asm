;;;;;;;; Game logic -- Entity ;;;;;;;;
;; General entity logic subroutines go here!

UpdateEntityMoving:
    JSR .UpdateEntityMoveCounter
    JSR .UpdateEntityPosition

    RTS

.UpdateEntityMoveCounter:
    IncrementMember entityAnimationCount
    CompareMember entityAnimationMax
    BEQ .UpdateEntityMoveCounterReset
    JMP .UpdateEntityMoveCounterDone
.UpdateEntityMoveCounterReset:
    WriteMember entityAnimationCount, #$00
    JSR .UpdateEntityAnimationFrame
.UpdateEntityMoveCounterDone:
    RTS

.UpdateEntityAnimationFrame:
    IncrementMember entityAnimationFrame
    CompareMember entityAnimationLength
    BEQ .UpdateEntityAnimationFrameReset
    JMP .UpdateEntityAnimationFrameDone
.UpdateEntityAnimationFrameReset:
    WriteMember entityAnimationFrame, #$00
.UpdateEntityAnimationFrameDone:
    RTS

.UpdateEntityPosition:
    ; Add lower DY to lower Y byte
    LDY #entityY
    LDA [currentEntity],Y
    CLC
    LDY #entityDY
    ADC [currentEntity],Y
    LDY #entityY
    STA [currentEntity],Y

    ; Add higher DY with carry to higher Y byte
    LDY #entityY
    INY
    LDA [currentEntity],Y
    LDY #entityDY
    INY
    ADC [currentEntity],Y
    LDY #entityY
    INY
    STA [currentEntity],Y

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

    RTS
