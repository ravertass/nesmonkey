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

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Constants ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Logic constants

DIR_UP    = $00
DIR_DOWN  = $01
DIR_LEFT  = $02
DIR_RIGHT = $03

IDLE    = $00
WALKING = $01

; Graphics constants


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000

monkeyY     .rs 1  ; Current Y coordinate of monkey.
monkeyX     .rs 1  ; Current X coordinate of monkey.
monkeyState .rs 1  ; Current monkey state (idle/walking).
monkeyDir   .rs 1  ; Current monkey direction.

controller1 .rs 1  ; Last input from controller 1.


; Variables set before updating sprites
currentEntityY    .rs 2
currentEntityX    .rs 2
currentMetaSprite .rs 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Setup ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 0
    .org $C000
RESET:
    .include "general_setup.asm"

; Load palettes
    LDA $2002    ; read PPU status to reset the high/low latch
    LDA #$3F
    STA $2006    ; write the high byte of $3F00 address
    LDA #$00
    STA $2006    ; write the low byte of $3F00 address
    LDX #$00
LoadPalettesLoop:
    LDA palette, x        ;load palette byte
    STA $2007             ;write to PPU
    INX                   ;set index to next byte
    CPX #$20
    BNE LoadPalettesLoop  ;if x = $20, 32 bytes copied, all done

    LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
    STA $2000
    LDA #%00011110   ; Enable sprites, enable background, no clipping on left side.
    STA $2001

; Initial monkey values
    LDA #$80
    STA monkeyX
    STA monkeyY
    LDA #DIR_DOWN
    STA monkeyDir
    LDA #IDLE
    STA monkeyState

Forever:
    JMP Forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Graphics logic ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateGraphics:
    ; Start DMA transfer from $0200
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    ; X will be the offset used to store all sprites at the correct
    ; place in memory.
    LDX #$00

    JSR UpdateMonkeySprites

    RTS

UpdateMonkeySprites:
    LDY monkeyY
    STY currentEntityY
    LDY monkeyX
    STY currentEntityX

    LDA monkeyDir
    CMP #DIR_DOWN
    JSR SetMonkeySpritesDown

    JSR UpdateCurrentEntitySprites
    RTS
SetMonkeySpritesDown:
    LDA monkeyState
    CMP #IDLE
    JSR SetMonkeySpritesDownIdle
    RTS
SetMonkeySpritesDownIdle:
    LDA #LOW(sprMonkeyDownIdle)
    STA currentMetaSprite
    LDA #HIGH(sprMonkeyDownIdle)
    LDY #$01
    STA currentMetaSprite, y
    RTS

UpdateCurrentEntitySprites:
    LDY #$00
UpdateCurrentEntitySpritesLoop:
    ; Y coordinate
    LDA [currentMetaSprite], y
    CMP #$FF ; No more sprites!
    BEQ UpdateCurrentEntitySpritesDone
    CLC
    ADC currentEntityY
    STA $0200, x
    INX
    INY

    ; Tile
    LDA [currentMetaSprite], y
    STA $0200, x
    INX
    INY

    ; Attribute
    LDA [currentMetaSprite], y
    STA $0200, x
    INX
    INY

    ; X coordinate
    LDA [currentMetaSprite], y
    CLC
    ADC currentEntityX
    STA $0200, x
    INX
    INY

    JMP UpdateCurrentEntitySpritesLoop

UpdateCurrentEntitySpritesDone:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Input logic ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetInput:
    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; VBlank ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

NMI:
    JSR UpdateGraphics
    JSR GetInput

    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Background and sprites ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    .bank 1
    .org $E000
palette:
    ; Background palette
    .db $22,$32,$02,$12,  $22,$37,$07,$17,  $22,$00,$00,$00,  $22,$00,$00,$00

    ; Sprite palette
    .db $22,$17,$37,$0F,  $22,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00

sprMonkeyDownIdle:
    ; Format: $y-offs, $tile-no, %attr, $x-offs
    ; Upper sprite
    .db $00, $14, %00000000, $00
    ; Lower sprite
    .db $08, $24, %00000000, $00
    ; End of sprites
    .db $FF

sprMonkeyDownWalking:
    ; Number of sprites in meta-sprite
    .db $02
    ; Number of sprites in animation
    .db $02
    ; Format: $x-offs, $y-offs, [$tile-no, %attr]
    ; Upper sprite
    .db $00, $00,    $15, %00000000,  $15, %01000000
    ; Lower sprite
    .db $00, $08,    $25, %00000000,  $25, %01000000

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
