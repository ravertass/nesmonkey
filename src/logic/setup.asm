;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "logic/setup_boomerang.asm"
    .include "logic/setup_monkey.asm"
    .include "logic/setup_entity_space.asm"
    .include "logic/new_seagull.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupBoomerang

    LDA #$04 ; number chosen randomly
    STA rngSeed
    LDA #$E0
    STA rngSeed+1

    JSR SetupEntitySpace
    JSR NewSeagull ; TODO: Seagulls should be added dynamically.

    RTS
