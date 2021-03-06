;;;;;;;; Game logic - Follow lookup table ;;;;;;;;
;; Generated file with subroutine for calculating the a follow movement vector.

; SUBROUTINE
; Calculates movement vector for following based on a minimized, positive difference vector.
; Input:
;     A: x in the minimized, positive difference vector.
;     X: Entity's speed.
; Output:
;     X: Positive X speed.
;     Y: Positive Y speed.
FollowMovementLookup:
    CMP #$01
    BNE .XNotEquals1
    JSR .XEquals1
    RTS
.XNotEquals1:
    CMP #$02
    BNE .XNotEquals2
    JSR .XEquals2
    RTS
.XNotEquals2:
    CMP #$03
    BNE .XNotEquals3
    JSR .XEquals3
    RTS
.XNotEquals3:
    CMP #$04
    BNE .XNotEquals4
    JSR .XEquals4
    RTS
.XNotEquals4:
    CMP #$05
    BNE .XNotEquals5
    JSR .XEquals5
    RTS
.XNotEquals5:
    CMP #$06
    BNE .XNotEquals6
    JSR .XEquals6
    RTS
.XNotEquals6:
    CMP #$07
    BNE .XNotEquals7
    JSR .XEquals7
    RTS
.XNotEquals7:
    RTS

.XEquals1:
    TXA
    CMP #$01
    BEQ .XEq1SpeedEq1
    CMP #$02
    BEQ .XEq1SpeedEq2
    CMP #$03
    BEQ .XEq1SpeedEq3
    CMP #$04
    BEQ .XEq1SpeedEq4
    CMP #$05
    BEQ .XEq1SpeedEq5
    CMP #$06
    BEQ .XEq1SpeedEq6
    CMP #$07
    BEQ .XEq1SpeedEq7
    CMP #$08
    BEQ .XEq1SpeedEq8
.XEq1SpeedEq1
    LDX #$01
    LDY #$01
    RTS
.XEq1SpeedEq2
    LDX #$01
    LDY #$01
    RTS
.XEq1SpeedEq3
    LDX #$02
    LDY #$02
    RTS
.XEq1SpeedEq4
    LDX #$03
    LDY #$03
    RTS
.XEq1SpeedEq5
    LDX #$04
    LDY #$04
    RTS
.XEq1SpeedEq6
    LDX #$04
    LDY #$04
    RTS
.XEq1SpeedEq7
    LDX #$05
    LDY #$05
    RTS
.XEq1SpeedEq8
    LDX #$06
    LDY #$06
    RTS

.XEquals2:
    TXA
    CMP #$01
    BEQ .XEq2SpeedEq1
    CMP #$02
    BEQ .XEq2SpeedEq2
    CMP #$03
    BEQ .XEq2SpeedEq3
    CMP #$04
    BEQ .XEq2SpeedEq4
    CMP #$05
    BEQ .XEq2SpeedEq5
    CMP #$06
    BEQ .XEq2SpeedEq6
    CMP #$07
    BEQ .XEq2SpeedEq7
    CMP #$08
    BEQ .XEq2SpeedEq8
.XEq2SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq2SpeedEq2
    LDX #$02
    LDY #$01
    RTS
.XEq2SpeedEq3
    LDX #$03
    LDY #$01
    RTS
.XEq2SpeedEq4
    LDX #$04
    LDY #$02
    RTS
.XEq2SpeedEq5
    LDX #$04
    LDY #$02
    RTS
.XEq2SpeedEq6
    LDX #$05
    LDY #$03
    RTS
.XEq2SpeedEq7
    LDX #$06
    LDY #$03
    RTS
.XEq2SpeedEq8
    LDX #$07
    LDY #$04
    RTS

.XEquals3:
    TXA
    CMP #$01
    BEQ .XEq3SpeedEq1
    CMP #$02
    BEQ .XEq3SpeedEq2
    CMP #$03
    BEQ .XEq3SpeedEq3
    CMP #$04
    BEQ .XEq3SpeedEq4
    CMP #$05
    BEQ .XEq3SpeedEq5
    CMP #$06
    BEQ .XEq3SpeedEq6
    CMP #$07
    BEQ .XEq3SpeedEq7
    CMP #$08
    BEQ .XEq3SpeedEq8
.XEq3SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq3SpeedEq2
    LDX #$02
    LDY #$01
    RTS
.XEq3SpeedEq3
    LDX #$03
    LDY #$01
    RTS
.XEq3SpeedEq4
    LDX #$04
    LDY #$01
    RTS
.XEq3SpeedEq5
    LDX #$05
    LDY #$02
    RTS
.XEq3SpeedEq6
    LDX #$06
    LDY #$02
    RTS
.XEq3SpeedEq7
    LDX #$07
    LDY #$02
    RTS
.XEq3SpeedEq8
    LDX #$08
    LDY #$03
    RTS

.XEquals4:
    TXA
    CMP #$01
    BEQ .XEq4SpeedEq1
    CMP #$02
    BEQ .XEq4SpeedEq2
    CMP #$03
    BEQ .XEq4SpeedEq3
    CMP #$04
    BEQ .XEq4SpeedEq4
    CMP #$05
    BEQ .XEq4SpeedEq5
    CMP #$06
    BEQ .XEq4SpeedEq6
    CMP #$07
    BEQ .XEq4SpeedEq7
    CMP #$08
    BEQ .XEq4SpeedEq8
.XEq4SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq4SpeedEq2
    LDX #$02
    LDY #$00
    RTS
.XEq4SpeedEq3
    LDX #$03
    LDY #$01
    RTS
.XEq4SpeedEq4
    LDX #$04
    LDY #$01
    RTS
.XEq4SpeedEq5
    LDX #$05
    LDY #$01
    RTS
.XEq4SpeedEq6
    LDX #$06
    LDY #$01
    RTS
.XEq4SpeedEq7
    LDX #$07
    LDY #$02
    RTS
.XEq4SpeedEq8
    LDX #$08
    LDY #$02
    RTS

.XEquals5:
    TXA
    CMP #$01
    BEQ .XEq5SpeedEq1
    CMP #$02
    BEQ .XEq5SpeedEq2
    CMP #$03
    BEQ .XEq5SpeedEq3
    CMP #$04
    BEQ .XEq5SpeedEq4
    CMP #$05
    BEQ .XEq5SpeedEq5
    CMP #$06
    BEQ .XEq5SpeedEq6
    CMP #$07
    BEQ .XEq5SpeedEq7
    CMP #$08
    BEQ .XEq5SpeedEq8
.XEq5SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq5SpeedEq2
    LDX #$02
    LDY #$00
    RTS
.XEq5SpeedEq3
    LDX #$03
    LDY #$01
    RTS
.XEq5SpeedEq4
    LDX #$04
    LDY #$01
    RTS
.XEq5SpeedEq5
    LDX #$05
    LDY #$01
    RTS
.XEq5SpeedEq6
    LDX #$06
    LDY #$01
    RTS
.XEq5SpeedEq7
    LDX #$07
    LDY #$01
    RTS
.XEq5SpeedEq8
    LDX #$08
    LDY #$02
    RTS

.XEquals6:
    TXA
    CMP #$01
    BEQ .XEq6SpeedEq1
    CMP #$02
    BEQ .XEq6SpeedEq2
    CMP #$03
    BEQ .XEq6SpeedEq3
    CMP #$04
    BEQ .XEq6SpeedEq4
    CMP #$05
    BEQ .XEq6SpeedEq5
    CMP #$06
    BEQ .XEq6SpeedEq6
    CMP #$07
    BEQ .XEq6SpeedEq7
    CMP #$08
    BEQ .XEq6SpeedEq8
.XEq6SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq6SpeedEq2
    LDX #$02
    LDY #$00
    RTS
.XEq6SpeedEq3
    LDX #$03
    LDY #$00
    RTS
.XEq6SpeedEq4
    LDX #$04
    LDY #$01
    RTS
.XEq6SpeedEq5
    LDX #$05
    LDY #$01
    RTS
.XEq6SpeedEq6
    LDX #$06
    LDY #$01
    RTS
.XEq6SpeedEq7
    LDX #$07
    LDY #$01
    RTS
.XEq6SpeedEq8
    LDX #$08
    LDY #$01
    RTS

.XEquals7:
    TXA
    CMP #$01
    BEQ .XEq7SpeedEq1
    CMP #$02
    BEQ .XEq7SpeedEq2
    CMP #$03
    BEQ .XEq7SpeedEq3
    CMP #$04
    BEQ .XEq7SpeedEq4
    CMP #$05
    BEQ .XEq7SpeedEq5
    CMP #$06
    BEQ .XEq7SpeedEq6
    CMP #$07
    BEQ .XEq7SpeedEq7
    CMP #$08
    BEQ .XEq7SpeedEq8
.XEq7SpeedEq1
    LDX #$01
    LDY #$00
    RTS
.XEq7SpeedEq2
    LDX #$02
    LDY #$00
    RTS
.XEq7SpeedEq3
    LDX #$03
    LDY #$00
    RTS
.XEq7SpeedEq4
    LDX #$04
    LDY #$00
    RTS
.XEq7SpeedEq5
    LDX #$05
    LDY #$00
    RTS
.XEq7SpeedEq6
    LDX #$06
    LDY #$00
    RTS
.XEq7SpeedEq7
    LDX #$07
    LDY #$00
    RTS
.XEq7SpeedEq8
    LDX #$08
    LDY #$00
    RTS
