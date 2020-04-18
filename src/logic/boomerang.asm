;;;;;;;; Game logic -- Boomerang ;;;;;;;;
;; Game logic related to the boomerang goes here.

;; Move the boomerang if it is active
UpdateBoomerang:
    ; TODO: Using entityActive like this does not work...
    ;       Since UpdateBoomerang won't be called if the boomerang is not active... >___<
    LoadEntity boomerangEntity
    EReadMemberToA entityActive
    CMP #$00
    BNE .BoomerangActive

    ; Boomerang not active
    LDA controller1
    AND #BUTTON_B
    BNE .BoomerangDone

    ; B button was pressed
    EWriteMember entityActive, #$01

    ; Set boomerang's coordinates to monkey's coordinates.
    LoadEntity monkeyEntity
    EReadMemberToA entityX, tempMonkeyCoordinate
    LoadEntity boomerangEntity
    EWriteMember16 entityX, tempMonkeyCoordinate

    LoadEntity monkeyEntity
    EReadMemberToA entityY, tempMonkeyCoordinate
    LoadEntity boomerangEntity
    EWriteMember16 entityY, tempMonkeyCoordinate

    JSR .SetBoomerangVelocity

    JMP .BoomerangDone

    ; If active:
    ; - Update dx and dy according to ddx and ddy
    ;   (should probably be generally done for entities)
    ; - If boomerang collision-detects with monkey:
    ;   - Kill boomerang
.BoomerangActive:

.BoomerangDone:
    RTS

.SetBoomerangVelocity:
    LDA controller1
    AND #BUTTON_LEFT
    BNE .NotLeft
    EWriteMember16 entityDX, #BOOMERANG_NEG_SPEED ; TODO: Should write DDX
.NotLeft:
    LDA controller1
    AND #BUTTON_RIGHT
    BNE .NotRight
    EWriteMember16 entityDX, #BOOMERANG_SPEED     ; TODO: Should write DDX
.NotRight:
    LDA controller1
    AND #BUTTON_UP
    BNE .NotUp
    EWriteMember16 entityDY, #BOOMERANG_NEG_SPEED ; TODO: Should write DDY
.NotUp:
    LDA controller1
    AND #BUTTON_DOWN
    BNE .NotUp
    EWriteMember16 entityDY, #BOOMERANG_SPEED     ; TODO: Should write DDY

    RTS
