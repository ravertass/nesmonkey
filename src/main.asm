;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; Mr. Monkey's Boomerang Bonanza! ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Made by sfabian                                                             ;;
;; Some code adapted from Nerdy Nights tutorial by bunnyboy @ NintendoAge.com  ;;
;; Contact: fabian.sorensson@gmail.com                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .list

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Includes... ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .include "util/macros.asm"

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

MONKEY_SPEED  = $0003
MONKEY_NEG_SPEED = $0000 - MONKEY_SPEED

BOOMERANG_MAX_SPEED = $08
BOOMERANG_MAX_SPEED_COUNTER = $05

    .rsset $0
TYPE_MONKEY    .rs 1
TYPE_SEAGULL   .rs 1
TYPE_BOOMERANG .rs 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Structs ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Entity

FLAG_IS_ACTIVE  = %00000001
FLAG_IS_MOVING  = %00000010
FLAG_IS_VISIBLE = %00000100

BOOMERANG_FLAG_IS_RETURNING = %10000000

SEAGULL_FLAG_HAS_APPEARED = %10000000

; Entity flags:
; 0  0  0  0  |  0  0  0  0
; ^  ^  ^  ^        ^  ^  ^
; |  |  |  |        |  |  |
; Reserved for      |  |  |
; different         |  |  |
; entity types.     |  |  |
;                   |  |  |
; Is visible _______|  |  |
; Is moving. __________|  |
; Is active. _____________|

    .rsset $0

entityFlags           .rs 1
entityType            .rs 1
entityX               .rs 2
entityY               .rs 2
entityDX              .rs 2
entityDY              .rs 2
entityWidth           .rs 1
entityHeight          .rs 1
entityCollisionOffset .rs 1
entityDir             .rs 1
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

; RAM start (parseable line! don't remove!)

    .zp

currentEntity    .ds 2
otherEntity      .ds 2

; Variables set before updating sprites
currentMetaSpritePointer .ds 2
currentMetaSpriteOffset  .ds 1
currentAnimationsTable   .ds 2

; Pointer used during graphics setup.
bgPointerLow  .ds 1
bgPointerHigh .ds 1

tempTilePointer .ds 2

    .bss

firstEntity      .ds 0
monkeyEntity     .ds entitySize
boomerangEntity  .ds entitySize
entitySpace      .ds entitySize*10
endOfEntitySpace .ds 0

lastDmaOffset .ds 1

; Last input from controller 1.
controller1 .ds 1

gameClock .ds 2

; Seed for random number generation.
rngSeed .ds 2

;; Temporary variables ;;

; TODO: Could probably do some cleanup among these.

; Counter used during animation
frameCounter .ds 1

tempCoordinate .ds 1
tempMonkeyCoordinate .ds 2
tempVariable  .ds 1

boomerangSpeed .ds 1
boomerangSpeedCounter .ds 1
boomerangTargetX .ds 1
boomerangTargetY .ds 1
boomerangMinAbsTargetX .ds 1
boomerangMinAbsTargetY .ds 1

    .org $0700

DMA_GRAPHICS .ds $FF

; RAM end (parseable line! don't remove!)

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
    .include "graphics/pixel_space.asm" ; TODO: Used by both logic and graphics...
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
