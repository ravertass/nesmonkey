;;;;;;;; Game logic -- Boomerang ;;;;;;;;
;; Game logic related to the boomerang goes here.

;; Move the boomerang if it is active
UpdateBoomerang:
    ECheckFlag #FLAG_IS_MOVING
    BEQ .BoomerangNotMoving
    JSR .BoomerangMoving
    RTS

.BoomerangNotMoving:
    ; Boomerang is idle.
    ; So, let's check if it is thrown.
    LDA controller1
    AND #BUTTON_B
    BNE .ButtonBPressed

    RTS

.ButtonBPressed:
    ESetFlag #FLAG_IS_MOVING
    ESetFlag #FLAG_IS_VISIBLE
    EUnsetFlag #BOOMERANG_FLAG_IS_RETURNING
    EWriteMember entityAnimationFrame, #$00

    ; Set boomerang's coordinates to monkey's coordinates.
    LoadEntity monkeyEntity
    EReadMember16ToP entityX, tempMonkeyCoordinate
    LoadEntity boomerangEntity
    EWriteMember16P entityX, tempMonkeyCoordinate

    LoadEntity monkeyEntity
    EReadMember16ToP entityY, tempMonkeyCoordinate
    LoadEntity boomerangEntity
    EWriteMember16P entityY, tempMonkeyCoordinate

    JSR .SetInitialBoomerangVelocity

    RTS

.BoomerangMoving:
    ; First, we calculate the boomerang speed. It should initially be decremented when moving
    ; away from the monkey, then incremented when returning towards the monkey.

    ECheckFlag #BOOMERANG_FLAG_IS_RETURNING
    BNE .BoomerangIsReturning

;BoomerangMovingAway:
    DecrementPointer boomerangSpeedCounter
    LDA boomerangSpeedCounter
    BNE .BoomerangAbsSpeedDone

    WritePointer boomerangSpeedCounter, #BOOMERANG_MAX_SPEED_COUNTER
    DecrementPointer boomerangSpeed
    LDA boomerangSpeed
    BNE .BoomerangAbsSpeedDone

    ; Speed hit 0, so it is time for the boomerang to return.
    ESetFlag #BOOMERANG_FLAG_IS_RETURNING
    IncrementPointer boomerangSpeed
    JMP .BoomerangAbsSpeedDone

.BoomerangIsReturning:
    LDA boomerangSpeed
    CMP #BOOMERANG_MAX_SPEED
    BEQ .BoomerangAbsSpeedDone

    DecrementPointer boomerangSpeedCounter
    LDA boomerangSpeedCounter
    BNE .BoomerangAbsSpeedDone

    WritePointer boomerangSpeedCounter, #BOOMERANG_MAX_SPEED_COUNTER
    IncrementPointer boomerangSpeed

.BoomerangAbsSpeedDone:
    ECheckFlag #BOOMERANG_FLAG_IS_RETURNING
    BEQ .SetBoomerangVelocity
    ; Boomerang is returning, so let's set the boomerangTargetX and boomerangTargetY values.
    JSR .CalculateMonkeyTarget

.SetBoomerangVelocity
    LDX boomerangTargetX
    LDY boomerangTargetY
    JSR MinimizeTargetVector
    STX boomerangMinAbsTargetX
    STY boomerangMinAbsTargetY

    IsPositive boomerangTargetX
    BNE .NotHalfRight
    JSR .HalfRight
    JMP .BoomerangVelocityDone
.NotHalfRight:
    JSR .HalfLeft

.BoomerangVelocityDone:
    ECheckFlag #BOOMERANG_FLAG_IS_RETURNING
    BEQ .Done

    ; If boomerang is returning, then we will check if boomerang and monkey collides.
    ; If so, the boomerang stops moving.
    LoadOtherEntity monkeyEntity
    JSR CollisionDetect
    BNE .Done
    EUnsetFlag #FLAG_IS_MOVING
    EUnsetFlag #FLAG_IS_VISIBLE

.Done:
    RTS

.HalfLeft:
    IsPositive boomerangTargetY
    BEQ .QuadrantLD
;QuadrantLU:
    LDA boomerangMinAbsTargetX
    CMP boomerangMinAbsTargetY
    BCC .OctantLUU
;OctantLLU:
    LDA boomerangMinAbsTargetX
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDY
    JSR GetHigherNegativeByte
    EWriteAToMember entityDY+1
    TXA
    NegateA
    EWriteAToMember entityDX
    JSR GetHigherNegativeByte
    EWriteAToMember entityDX+1
    JMP .HalfLeftDone
.OctantLUU:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    JSR GetHigherNegativeByte
    EWriteAToMember entityDX+1
    TXA
    NegateA
    EWriteAToMember entityDY
    JSR GetHigherNegativeByte
    EWriteAToMember entityDY+1
    JMP .HalfLeftDone

.QuadrantLD:
    LDA boomerangMinAbsTargetX
    CMP boomerangMinAbsTargetY
    BCC .OctantLDD
;OctantLLD:
    LDA boomerangMinAbsTargetX
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00
    TXA
    NegateA
    EWriteAToMember entityDX
    JSR GetHigherNegativeByte
    EWriteAToMember entityDX+1
    JMP .HalfLeftDone
.OctantLDD:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    JSR GetHigherNegativeByte
    EWriteAToMember entityDX+1
    TXA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00

.HalfLeftDone:
    RTS

.HalfRight:
    IsPositive boomerangTargetY
    BEQ .QuadrantRD
;QuadrantRU:
    LDA boomerangMinAbsTargetX
    CMP boomerangMinAbsTargetY
    BCC .OctantRUU
;OctantRRU:
    LDA boomerangMinAbsTargetX
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDY
    JSR GetHigherNegativeByte
    EWriteAToMember entityDY+1
    TXA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    JMP .HalfRightDone
.OctantRUU:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    TXA
    NegateA
    EWriteAToMember entityDY
    JSR GetHigherNegativeByte
    EWriteAToMember entityDY+1
    JMP .HalfRightDone

.QuadrantRD:
    LDA boomerangMinAbsTargetX
    CMP boomerangMinAbsTargetY
    BCC .OctantRDD
;OctantRRD:
    LDA boomerangMinAbsTargetX
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00
    TXA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    JMP .HalfRightDone
.OctantRDD:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$00
    TXA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$00

.HalfRightDone:
    RTS

.SetInitialBoomerangVelocity:
    WritePointer boomerangSpeed, #BOOMERANG_MAX_SPEED
    WritePointer boomerangSpeedCounter, #$10
    WritePointer boomerangTargetX, #$00
    WritePointer boomerangTargetY, #$00

    ; Start by loading the monkey's dir into X.
    LoadEntity monkeyEntity
    EReadMemberToA entityDir
    TAX
    LoadEntity boomerangEntity

    LDA controller1
    AND #BUTTON_LEFT
    BNE .GoLeft
    TXA
    CMP #DIR_LEFT
    BNE .NotLeft
.GoLeft:
    WritePointer boomerangTargetX, #$FF
.NotLeft:
    LDA controller1
    AND #BUTTON_RIGHT
    BNE .GoRight
    TXA
    CMP #DIR_RIGHT
    BNE .NotRight
.GoRight:
    WritePointer boomerangTargetX, #$01
.NotRight:
    LDA controller1
    AND #BUTTON_UP
    BNE .GoUp
    TXA
    CMP #DIR_UP
    BNE .NotUp
.GoUp:
    WritePointer boomerangTargetY, #$FF
.NotUp:
    LDA controller1
    AND #BUTTON_DOWN
    BNE .GoDown
    TXA
    CMP #DIR_DOWN
    BNE .NotDown
.GoDown:
    WritePointer boomerangTargetY, #$01
.NotDown:

    RTS



; SUBROUTINE
; Calculates the difference between the boomerang's X and Y values and the monkey's X and Y
; values (in pixel space), and put them in boomerangTargetX and boomerangTargetY.
; Output:
;     boomerangTargetX: Difference between boomerang's X value and monkey's X value.
;     boomerangTargetY: Difference between boomerang's Y value and monkey's Y value.
; Clobbers:
;     A, Y
.CalculateMonkeyTarget:
    LoadEntity boomerangEntity
    LDY #entityX
    JSR CoordinateToPixelSpace
    STA boomerangTargetX

    LoadEntity monkeyEntity
    LDY #entityX
    JSR CoordinateToPixelSpace
    SEC
    SBC boomerangTargetX
    BMI .XNegative
;XPositive:
    BCS .StoreX
    LDA #$80
    JMP .StoreX
.XNegative:
    BCC .StoreX
    LDA #$7F
.StoreX:
    STA boomerangTargetX

    LoadEntity boomerangEntity
    LDY #entityY
    JSR CoordinateToPixelSpace
    STA boomerangTargetY

    LoadEntity monkeyEntity
    LDY #entityY
    JSR CoordinateToPixelSpace
    SEC
    SBC boomerangTargetY
    BMI .YNegative
;YPositive:
    BCS .StoreY
    LDA #$80
    JMP .StoreY
.YNegative:
    BCC .StoreY
    LDA #$7F
.StoreY:
    STA boomerangTargetY

    LoadEntity boomerangEntity
    RTS



; SUBROUTINE
; If accumulator is 0, we keep it that way.
; Otherwise, we write #$FF to the accumulator.
; Input:
;    A: Lower negative byte (or zero).
; Output:
;    A: Higher negative byte (or zero).
GetHigherNegativeByte:
    CMP #$00
    BEQ .GetHigherNegativeByteDone
    LDA #$FF
.GetHigherNegativeByteDone:
    RTS
