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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Structs ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Entity

    .rsset $0
entityActive          .rs 1
entityType            .rs 1
entityX               .rs 1
entityY               .rs 1
entityDir             .rs 1
entityDX              .rs 1
entityDY              .rs 1
entityAnimationCount  .rs 1
entityAnimationMax    .rs 1
entityAnimationFrame  .rs 1
entityOverridePalette .rs 1
entityState           .rs 1
entityAnimationsTable .rs 2
entitySize            .rs 0

;; Animations table

    .rsset $0
animationsUpIdle      .rs 2
animationsDownIdle    .rs 2
animationsLeftIdle    .rs 2
animationsRightIdle   .rs 2
animationsUpMoving    .rs 2
animationsDownMoving  .rs 2
animationsLeftMoving  .rs 2
animationsRightMoving .rs 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .zp

currentEntity .ds 2
monkeyEntity  .ds entitySize

controller1 .ds 1  ; Last input from controller 1.

; Variables set before updating sprites
currentMetaSpritePointer .ds 2
currentMetaSpriteOffset  .ds 1
currentAnimationsTable   .ds 2

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