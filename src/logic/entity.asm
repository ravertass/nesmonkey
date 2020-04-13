;;;;;;;; Game logic -- Entity ;;;;;;;;
;; General entity logic subroutines go here!

UpdateEntityMoving:
    JSR .UpdateEntityMoveCounter
    JSR .UpdateEntityPosition

    RTS

.UpdateEntityMoveCounter:
    EIncrementMember entityAnimationCount
    ECompareMember entityAnimationMax
    BEQ .UpdateEntityMoveCounterReset
    JMP .UpdateEntityMoveCounterDone
.UpdateEntityMoveCounterReset:
    EWriteMember entityAnimationCount, #$00
    JSR .UpdateEntityAnimationFrame
.UpdateEntityMoveCounterDone:
    RTS

.UpdateEntityAnimationFrame:
    EIncrementMember entityAnimationFrame
    ECompareMember entityAnimationLength
    BEQ .UpdateEntityAnimationFrameReset
    JMP .UpdateEntityAnimationFrameDone
.UpdateEntityAnimationFrameReset:
    EWriteMember entityAnimationFrame, #$00
.UpdateEntityAnimationFrameDone:
    RTS

.UpdateEntityPosition:
    ; Add lower DY to lower Y byte
    EReadMemberToA entityDY
    CLC
    EAddAToMember entityY

    ; Add higher DY with carry to higher Y byte
    EReadMemberToA entityDY+1
    EAddAToMember entityY+1

    ; Add lower DX to lower X byte
    EReadMemberToA entityDX
    CLC
    EAddAToMember entityX

    ; Add higher DX with carry to higher X byte
    EReadMemberToA entityDX+1
    EAddAToMember entityX+1

    RTS
