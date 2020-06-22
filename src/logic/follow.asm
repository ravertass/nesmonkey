;;;;;;;; Game logic -- Follow ;;;;;;;;
;; Subroutine for letting the current entity follow a target.

; SUBROUTINE ;
FollowTarget:
    LDX followTargetX
    LDY followTargetY
    JSR MinimizeTargetVector
    STX followMinAbsTargetX
    STY followMinAbsTargetY

    IsPositive followTargetX
    BNE .NotHalfRight

    JSR .HalfRight
    RTS

.NotHalfRight:
    JSR .HalfLeft
    RTS


; SUBROUTINE ;
.HalfLeft:
    IsPositive followTargetY
    BEQ .QuadrantLD
;QuadrantLU:
    LDA followMinAbsTargetX
    CMP followMinAbsTargetY
    BCC .OctantLUU
;OctantLLU:
    LDA followMinAbsTargetX
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDY
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDY+1
    TXA
    NegateA
    EWriteAToMember entityDX
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDX+1
    JMP .HalfLeftDone
.OctantLUU:
    LDA followMinAbsTargetY
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDX+1
    TXA
    NegateA
    EWriteAToMember entityDY
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDY+1
    JMP .HalfLeftDone

.QuadrantLD:
    LDA followMinAbsTargetX
    CMP followMinAbsTargetY
    BCC .OctantLDD
;OctantLLD:
    LDA followMinAbsTargetX
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00
    TXA
    NegateA
    EWriteAToMember entityDX
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDX+1
    JMP .HalfLeftDone
.OctantLDD:
    LDA followMinAbsTargetY
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDX+1
    TXA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00

.HalfLeftDone:
    RTS


; SUBROUTINE ;
.HalfRight:
    IsPositive followTargetY
    BEQ .QuadrantRD
;QuadrantRU:
    LDA followMinAbsTargetX
    CMP followMinAbsTargetY
    BCC .OctantRUU
;OctantRRU:
    LDA followMinAbsTargetX
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDY
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDY+1
    TXA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    JMP .HalfRightDone
.OctantRUU:
    LDA followMinAbsTargetY
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    TXA
    NegateA
    EWriteAToMember entityDY
    JSR .GetHigherNegativeByte
    EWriteAToMember entityDY+1
    JMP .HalfRightDone

.QuadrantRD:
    LDA followMinAbsTargetX
    CMP followMinAbsTargetY
    BCC .OctantRDD
;OctantRRD:
    LDA followMinAbsTargetX
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00
    TXA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    JMP .HalfRightDone
.OctantRDD:
    LDA followMinAbsTargetY
    LDX followSpeed
    JSR FollowMovementLookup
    TYA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    TXA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00

.HalfRightDone:
    RTS


; SUBROUTINE
; If accumulator is 0, we keep it that way.
; Otherwise, we write #$FF to the accumulator.
; Input:
;    A: Lower negative byte (or zero).
; Output:
;    A: Higher negative byte (or zero).
.GetHigherNegativeByte:
    CMP #$00
    BEQ .GetHigherNegativeByteDone
    LDA #$FF
.GetHigherNegativeByteDone:
    RTS


; SUBROUTINE
; Calculates the difference between the current entity's X and Y coordinates and
; the monkey's X and Y coordinates (in pixel space), and put them in
; followTargetX and followTargetY.
; Output:
;     followTargetX: Difference between current entity's X coordinate and monkey's X coordinate.
;     followTargetY: Difference between current entity's Y coordinate and monkey's Y coordinate.
; Clobbers:
;     A, Y
SetMonkeyTarget:
    LoadOtherEntity monkeyEntity

    LDY #entityX
    JSR CoordinateToPixelSpace
    STA followTargetX

    SwapEntities
    LDY #entityX
    JSR CoordinateToPixelSpace
    SEC
    SBC followTargetX
    BMI .XNegative
;XPositive:
    BCS .StoreX
    LDA #$80
    JMP .StoreX
.XNegative:
    BCC .StoreX
    LDA #$7F
.StoreX:
    STA followTargetX

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace
    STA followTargetY

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace
    SEC
    SBC followTargetY
    BMI .YNegative
;YPositive:
    BCS .StoreY
    LDA #$80
    JMP .StoreY
.YNegative:
    BCC .StoreY
    LDA #$7F
.StoreY:
    STA followTargetY

    SwapEntities
    RTS
