;;;;;;;; Input logic ;;;;;;;;
;; Logic related to reading controllers goes here.

; At the end of GetInput, controller1 will contain
; the button presses from the first controller.
GetInput:
    ; This tells the controller's to latch the buttons' current status.
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016

    LDX #$08
GetInputLoop:
    LDA $4016
    LSR A            ; bit0 -> carry
    ROL controller1  ; controller1 <- carry
    DEX
    BNE GetInputLoop

    RTS

; Bit order: A- B- Se St Up Do Le Ri
BUTTON_A      = %10000000
BUTTON_B      = %01000000
BUTTON_SELECT = %00100000
BUTTON_START  = %00010000
BUTTON_UP     = %00001000
BUTTON_DOWN   = %00000100
BUTTON_LEFT   = %00000010
BUTTON_RIGHT  = %00000001
BUTTON_DIRS   = %00001111
