;;;;;;;; Game logic -- Boomerang ;;;;;;;;
;; Game logic related to the boomerang goes here.

; SUBROUTINE ;
UpdateBoomerang:
    ECheckFlag #FLAG_IS_MOVING
    BEQ .NotMoving

    JSR .BoomerangMoving
    RTS

.NotMoving:
    JSR .BoomerangNotMoving
    RTS


; SUBROUTINE ;
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

    JSR .SetInitialBoomerangTarget

    RTS


; SUBROUTINE ;
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
    BNE .BoomerangTargetReturning

    LDA boomerangTargetX
    STA followTargetX
    LDA boomerangTargetY
    STA followTargetY

    JMP .BoomerangFollowTarget

.BoomerangTargetReturning:
    JSR SetMonkeyTarget

.BoomerangFollowTarget:
    LDA boomerangSpeed
    STA followSpeed

    JSR FollowTarget

;MonkeyCollisionCheck:
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


; SUBROUTINE ;
.SetInitialBoomerangTarget:
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
