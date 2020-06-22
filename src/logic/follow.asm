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
