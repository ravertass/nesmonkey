;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "logic/setup_boomerang.asm"
    .include "logic/setup_monkey.asm"
    .include "logic/new_seagull.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupBoomerang

    LDA #$04 ; chosen by fair dice roll.
             ; guaranteed to be random.
    STA rngSeed
    LDA #$E0
    STA rngSeed+1

    ; TODO: Seagulls should be added dynamically.
    JSR NewSeagull
    JSR NewSeagull
    JSR NewSeagull
    JSR NewSeagull

    RTS
