;;;;;;;; Random numbers ;;;;;;;;
;; Subroutines for generating random numbers.

; SUBROUTINE
; Input:
;   variable rngSeed: Seed used for generating random number.
; Output:
;   variable rngSeed: New seed to create next random number.
;   A: A random byte.
; Clobbers:
;   X
RandomByte:
    LDX #8 ; iteration counter
    LDA rngSeed
.RandomByteLoop:
    ASL A
    ROL rngSeed+1
    BCC .SkipXOR
    EOR #$2D
.SkipXOR:
    DEX
    BNE .SkipXOR
    STA rngSeed

    RTS
