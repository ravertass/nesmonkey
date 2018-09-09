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

MONKEY_SPEED_LOW  = $03
MONKEY_SPEED_HIGH = $00
MONKEY_NEG_SPEED_LOW  = $00 - MONKEY_SPEED_LOW
MONKEY_NEG_SPEED_HIGH = $FF

    .rsset $0
TYPE_MONKEY  .rs 1
TYPE_SEAGULL .rs 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Structs ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Entity

    .rsset $0
entityActive          .rs 1 ; TODO: Change this into entityFlags
entityType            .rs 1
entityX               .rs 2
entityY               .rs 2
entityDX              .rs 2
entityDY              .rs 2
entityDir             .rs 1 ; TODO: Dir and State could be one.
entityState           .rs 1 ; They could also be put into entityFlags.
entityAnimationCount  .rs 1
entityAnimationMax    .rs 1
entityAnimationFrame  .rs 1
entityAnimationLength .rs 1
entityOverridePalette .rs 1
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

currentEntity    .ds 2
firstEntity      .ds 0
monkeyEntity     .ds entitySize
entitySpace      .ds entitySize*10
endOfEntitySpace .ds 0

controller1 .ds 1  ; Last input from controller 1.

; Variables set before updating sprites
currentMetaSpritePointer .ds 2
currentMetaSpriteOffset  .ds 1
currentAnimationsTable   .ds 2

; Counter used during animation (due to lack of registers...)
frameCounter .ds 1

tempCoordinate .ds 1

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
    .include "graphics/setup.asm"
    .include "logic/setup.asm"

RESET:
    SetupGeneral
    JSR SetupGraphics
    JSR SetupGame

Forever:
    JMP Forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; VBlank ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "graphics/graphics.asm"
    .include "input/input_logic.asm"
    .include "logic/logic.asm"

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

    .include "content/palette.asm"
    .include "content/sprites.asm"

    .org $EA00    ; kind of arbitrarily chosen (but the lower byte must be $00)

    .include "content/background.asm"

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

    .incbin "content/monkey.chr"
