; SUBROUTINE
; Input:
;     currentEntity
;     Y: Pointer to least significant byte of 2-byte value that should be divided by 4.
; Output:
;     A: The value divided by four (least significant bytes).
CoordinateToPixelSpace:
    ; This mess should divide the 2 byte coordinate by 4, taking the least significant byte as
    ; the actual coordinate.
    INY
    LDA [currentEntity],Y ; high
    LSR A
    DEY
    LDA [currentEntity],Y ; low
    ROR A
    STA tempCoordinate ; low/2 with most significant byte from high

    INY
    LDA [currentEntity],Y ; high
    LSR A
    LSR A
    LDA tempCoordinate
    ROR A ; low/4 with 2 most significant bytes from high
    ADC #$00 ; add the carry for more correct rounding

    RTS

; SUBROUTINE
; Input:
;     currentEntity
;     A: Coordinate in pixel space.
;     Y: Pointer to least significant byte of 2-byte coordinate where output should be
;        saved.
; Output:
;     [currentEntity],Y: Coordinate in game space.
; Clobbers:
;     X
CoordinateToGameSpace:
    STA tempCoordinate ; low/4

    ASL A ; low/2
    LDA #$00
    ROL A ; high/2
    TAX

    LDA tempCoordinate ; low/4
    ASL A ; low/2
    ASL A ; low
    STA [currentEntity],Y ; low

    TXA ; high/2
    ROL A ; high
    INY
    STA [currentEntity],Y ; high

    RTS
