;;;;;;;; Graphics setup -- Background ;;;;;;;;
;; Logic for loading background into memory goes here.

DrawTheBackground:
    LDA #$00    ; the lower byte of the background's place in memory must be $00
    STA bgPointerLow
    LDA #HIGH(background)
    STA bgPointerHigh
    JSR DrawBackground

    RTS


DrawBackground:
    LDA $2002             ; read PPU status to reset the high/low latch
    LDA #$20
    STA $2006             ; write the high byte of $2000 address
    LDA #$00
    STA $2006             ; write the low byte of $2000 address

    LDX #$00
    LDY #$00
; This loop will run 256*4 = 32*32 = 1024 times, which is the number of tiles on a background.
; (I think? Shouldn't it be 32*30?)
DrawBackgroundLoop:
    LDA [bgPointerLow], y
    STA $2007

    INY
    ; Inner loop done when y has been incremented 256 times.
    CPY #$00
    BNE DrawBackgroundLoop

    INC bgPointerHigh
    INX
    ; Outer loop done when x has been incremented 4 times.
    CPX #$04
    BNE DrawBackgroundLoop

    RTS
