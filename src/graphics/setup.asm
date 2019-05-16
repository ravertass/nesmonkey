;;;;;;;; Graphics setup ;;;;;;;;
;; Code for setting up graphics.

    .include "graphics/setup_background.asm"

SetupGraphics:
    JSR SetupPalette

    JSR DrawTheBackground

    LDA #%10000000   ; enable NMI, both sprites and background from pattern table 0
    STA $2000
    LDA #%00011110   ; Enable sprites, enable background, no clipping on left side.
    STA $2001

    RTS

SetupPalette:
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

    RTS
