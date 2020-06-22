;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "logic/setup_boomerang.asm"
    .include "logic/setup_monkey.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupBoomerang

    LDA #$04 ; chosen by fair dice roll.
             ; guaranteed to be random.
    STA rngSeed
    LDA #$00
    STA rngSeed+1

    LDA #$00
    STA gameClock
    STA gameClock+1

    RTS
