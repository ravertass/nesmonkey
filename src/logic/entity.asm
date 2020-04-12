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
    ReadMemberToA entityDY
    CLC
    AddAToMember entityY

    ; Add higher DY with carry to higher Y byte
    ReadMemberToA entityDY+1
    AddAToMember entityY+1

    ; Add lower DX to lower X byte
    ReadMemberToA entityDX
    CLC
    AddAToMember entityX

    ; Add higher DX with carry to higher X byte
    ReadMemberToA entityDX+1
    AddAToMember entityX+1

    RTS
