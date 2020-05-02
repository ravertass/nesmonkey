;;;;;;;; Game logic -- Boomerang ;;;;;;;;
;; Game logic related to the boomerang goes here.

;; Move the boomerang if it is active
UpdateBoomerang:
    ; TODO: Using entityActive like this does not work...
    ;       Since UpdateBoomerang won't be called if the boomerang is not active... >___<
    LoadEntity boomerangEntity
    EReadMemberToA entityState
    CMP #MOVING
    BEQ .BoomerangMoving

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

    JSR .SetBoomerangVelocity

    JMP .BoomerangDone

.BoomerangMoving:
    ; If moving:
    ; - Update dx and dy according to ddx and ddy
    ;   (should probably be generally done for entities)
    ; - If boomerang collision-detects with monkey:
    ;   - Kill boomerang

.BoomerangDone:
    RTS

.SetBoomerangVelocity:
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
    EWriteMember16 entityDX, #BOOMERANG_NEG_SPEED
.NotLeft:
    LDA controller1
    AND #BUTTON_RIGHT
    BNE .GoRight
    TXA
    CMP #DIR_RIGHT
    BNE .NotRight
.GoRight:
    EWriteMember16 entityDX, #BOOMERANG_SPEED
.NotRight:
    LDA controller1
    AND #BUTTON_UP
    BNE .GoUp
    TXA
    CMP #DIR_UP
    BNE .NotUp
.GoUp:
    EWriteMember16 entityDY, #BOOMERANG_NEG_SPEED
.NotUp:
    LDA controller1
    AND #BUTTON_DOWN
    BNE .GoDown
    TXA
    CMP #DIR_DOWN
    BNE .NotDown
.GoDown:
    EWriteMember16 entityDY, #BOOMERANG_SPEED
.NotDown:

    RTS
