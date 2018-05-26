;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; Mr. Monkey's Boomerang Bonanza! ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Made by sfabian                                                             ;;
;; Some code adapted from Nerdy Nights tutorial by bunnyboy @ NintendoAge.com  ;;
;; Contact: fabian.sorensson@gmail.com                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; Header ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "header.asm"
    Header

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Constants ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Logic constants

DIR_UP    = $00
DIR_DOWN  = $01
DIR_LEFT  = $02
DIR_RIGHT = $03

IDLE   = $00
MOVING = $01

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .zp

monkeyY              .ds 1  ; Current Y coordinate of monkey.
monkeyX              .ds 1  ; Current X coordinate of monkey.
monkeyState          .ds 1  ; Current monkey state (idle/walking).
monkeyDir            .ds 1  ; Current monkey direction.
monkeyMoveCounter    .ds 1  ; Counter used to update animation frame counter.
monkeyAnimationFrame .ds 1  ; Current frame in monkey's animation.

controller1 .ds 1  ; Last input from controller 1.

; Variables set before updating sprites
currentEntityY           .ds 1
currentEntityX           .ds 1
currentMetaSpritePointer .ds 2
currentAnimationFrame    .ds 1

; Counter used during animation (due to lack of registers...)
frameCounter .ds 1

; Pointer used during graphics setup.
bgPointerLow  .ds 1
bgPointerHigh .ds 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Setup ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .code
    .bank 0
    .org $C000

    .include "general_setup.asm"
    .include "graphics_setup.asm"
    .include "game_setup.asm"

RESET:
    SetupGeneral
    JSR SetupGraphics
    JSR SetupGame

Forever:
    JMP Forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; VBlank ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "graphics_logic.asm"
    .include "input_logic.asm"
    .include "game_logic.asm"

NMI:
    JSR UpdateGraphics
    JSR GetInput
    JSR UpdateGame

    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Background and sprites ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .data
    .bank 1
    .org $E000

    .include "palette.asm"
    .include "sprites.asm"

    .org $EA00    ; kind of arbitrarily chosen (but the lower byte must be $00)

    .include "background.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Interrupt vectors ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .org $FFFA     ; Where the interrupt vectors should be.
    .dw NMI        ; When it is time for vblank.
    .dw RESET      ; When the processor first turns on or is reset.
    .dw 0          ; External interrupt IRQ are deactivated.

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Graphics memory ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 2
    .org $0000

    .incbin "monkey.chr"
