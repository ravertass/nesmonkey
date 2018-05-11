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
;;;;;; RAM variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000

monkeyX     .rs 1  ; Current X coordinate of monkey.
monkeyImage .rs 1  ; Current sprite of monkey.
monkeyAttr  .rs 1  ; Current monkey sprite attributes.
monkeyY     .rs 1  ; Current Y coordinate of monkey.

controller1 .rs 1  ; Last input from controller 1.

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
    LDA #$14
    STA monkeyImage
    LDA #$00
    STA monkeyAttr

Forever:
    JMP Forever

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Graphics logic ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

NMI:
    ; Start DMA transfer from $0200
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    ; Set monkey sprite in memory
    LDA monkeyX
    STA $0200
    LDA monkeyImage
    STA $0201
    LDA monkeyAttr
    STA $0202
    LDA monkeyY
    STA $0203

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
    .db $22,$0F,$37,$17,  $22,$00,$00,$00,  $00,$00,$00,$00,  $00,$00,$00,$00

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
