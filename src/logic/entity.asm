;;;;;;;; Game logic -- Entity ;;;;;;;;
;; General entity logic subroutines go here!

; SUBROUTINE
; General movement update.
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

    EReadMemberToA entityType
    CMP #TYPE_MONKEY
    BEQ .DoWaterCollisionY
    CMP #TYPE_TEETH
    BEQ .DoWaterCollisionY
    JMP .NoWaterCollisionY
.DoWaterCollisionY:
    JSR WaterCollisionY
.NoWaterCollisionY:

    ; Add lower DX to lower X byte
    EReadMemberToA entityDX
    CLC
    EAddAToMember entityX

    ; Add higher DX with carry to higher X byte
    EReadMemberToA entityDX+1
    EAddAToMember entityX+1

    EReadMemberToA entityType
    CMP #TYPE_MONKEY
    BEQ .DoWaterCollisionX
    CMP #TYPE_TEETH
    BEQ .DoWaterCollisionX
    JMP .NoWaterCollisionX
.DoWaterCollisionX:
    JSR WaterCollisionX
.NoWaterCollisionX:

    RTS

; SUBROUTINE
; Clamps the current entity's position to the screen.
; Input:
;   currentEntity
; Clobbers:
;   A, Y
ClampToScreen:
    ELessThan16 entityX, #$0000
    BNE .RightOfXMin
    EWriteMember16 entityX, #$0000
.RightOfXMin:

    ELessThan16 entityY, #$001D
    BNE .BelowYMin
    EWriteMember16 entityY, #$001D
.BelowYMin:

    ELessThan16 entityX, #$03E0
    BEQ .LeftOfXMax
    EWriteMember16 entityX, #$03E0
.LeftOfXMax:

    ELessThan16 entityY, #$0372
    BEQ .AboveYMax
    EWriteMember16 entityY, #$0372
.AboveYMax:

    RTS
