;;;;;;;; Game logic -- Boomerang ;;;;;;;;
;; Game logic related to the boomerang goes here.

;; Move the boomerang if it is active
UpdateBoomerang:
    ; TODO: Using entityActive like this does not work...
    ;       Since UpdateBoomerang won't be called if the boomerang is not active... >___<
    LoadEntity boomerangEntity
    EReadMemberToA entityState
    CMP #MOVING
    BNE .BoomerangNotMoving
    JSR .BoomerangMoving

.BoomerangNotMoving:
    ; Boomerang is idle.
    ; So, let's check if it is thrown.
    LDA controller1
    AND #BUTTON_B
    BEQ .BoomerangDone

    ; B button was pressed.
    EWriteMember entityState, #MOVING
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

.BoomerangDone:
    RTS

.BoomerangMoving:
    ; First, we calculate the boomerang speed. It should initially be decremented when moving
    ; away from the monkey, then incremented when moving towards the monkey.
    ; TODO: Add incrementing when moving towards the monkey.
    DecrementPointer boomerangSpeedCounter
    LDA boomerangSpeedCounter
    BNE .BoomerangAbsSpeedDone

    WritePointer boomerangSpeedCounter, #$08
    DecrementPointer boomerangSpeed
    LDA boomerangSpeed
    BNE .BoomerangAbsSpeedDone

    ; Time for boomerang to turn around...
    ; TODO: Implement

.BoomerangAbsSpeedDone:
    ; Let's calculate the monkey's directional speed.
    ; TODO: Add support for moving towards the monkey...
    ; It's probably already supported, as long as boomerangTargetX is set correctly.

    LDX boomerangTargetX
    LDY boomerangTargetY
    JSR MinimizeTargetVector
    STX boomerangMinAbsTargetX
    STY boomerangMinAbsTargetY

    IsPositive boomerangTargetX
    BNE .NotHalfRight
    JSR .HalfRight
.NotHalfRight:
    JSR .HalfLeft

    ; TODO
    ; - If boomerang collision-detects with monkey:
    ;   - Kill boomerang

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
    EWriteMember entityDY+1, #$FF
    TXA
    NegateA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$FF
    JMP .HalfLeftDone
.OctantLUU:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$FF
    TXA
    NegateA
    EWriteAToMember entityDY
    EWriteMember entityDY+1, #$FF
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
    EWriteMember entityDX+1, #$00
    TXA
    NegateA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$FF
    JMP .HalfLeftDone
.OctantLDD:
    LDA boomerangMinAbsTargetY
    LDX boomerangSpeed
    JSR BoomerangMovementLookup
    TYA
    NegateA
    EWriteAToMember entityDX
    EWriteMember entityDX+1, #$FF
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
    EWriteMember entityDY+1, #$FF
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
    EWriteMember entityDY+1, #$FF
    EWriteMember entityDY+1, #$00
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
    WritePointer boomerangSpeed, #$08
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
