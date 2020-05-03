;; SUBROUTINE
;; Input:
;;     Y register: Pointer to least significant byte of 2-byte value that should be divided by 4.
;; Output:
;;     A register: The value divided by four (least significant bytes).
CoordinateToPixelSpace:
    ; This mess should divide the 2 byte coordinate by 4, taking the least significant byte as
    ; the actual coordinate.
    INY
    LDA [currentEntity],Y
    LSR A
    DEY
    LDA [currentEntity],Y
    ROR A
    STA tempCoordinate
    INY
    LDA [currentEntity],Y
    LSR A
    LSR A
    LDA tempCoordinate
    ROR A
    ADC #$00 ; add the carry for more correct rounding

    RTS
