;;;;;;;; Boomerang movement - minimize vector ;;;;;;;;
;; Logic for making a target vector minimized and absolute.

; SUBROUTINE
; Calculates a minimized, absoluet vector from a target vector.
; Input:
;     X: Target X.
;     Y: Target Y.
; Output:
;     X: Minimized, absolute target X.
;     Y: Minimized, absolute target Y.
MinimizeTargetVector:
    ; First, we calculate absolute values for X and Y.
    TXA
    BPL .XIsPositive
    NegateA
    TAX
.XIsPositive:
    TYA
    BPL .YIsPositive
    NegateA
    TAY
.YIsPositive:

    ; Time to minimize.
    ; First, we handle if some value is zero.
    TXA
    BNE .XIsNotZero
    ; If X is 0, we load 7 into Y, which represents infinity.
    LDY #$07
    RTS
.XIsNotZero:
    TYA
    BNE .YIsNotZero
    ; If Y is 0, we load 7 into X, which represents infinity.
    LDX #$07
    RTS
.YIsNotZero:

.ShiftingLoop:
    ; Now, we will shift until one value is 1.
    TXA
    CMP #$01
    BNE .XIsOne
    TYA
    CMP #$01
    BNE .YIsOne

    ; No value was one, so let's shift
    TXA
    LSR A
    TAX
    TYA
    LSR A
    TAY
    JMP .ShiftingLoop

    ; Finally, se clamp the non-one value to to 7 or less.
.XIsOne:
    TYA
    CMP #$07
    BCC .Done
    LDY #$07
.YIsOne
    TXA
    CMP #$07
    BCC .Done
    LDX #$07

.Done:
    RTS
