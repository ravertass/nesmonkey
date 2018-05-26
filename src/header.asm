;;;;;;;; Header ;;;;;;;;
;; Setup of memory etc.

Header:    .macro
    .inesprg 1   ; 1x 16KB PRG code
    .ineschr 1   ; 1x  8KB CHR data
    .inesmap 0   ; Mapper 0 = NROM, no bank swapping
    .inesmir 1   ; Background mirroring

    .endm
