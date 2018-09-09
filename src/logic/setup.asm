;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "logic/setup_monkey.asm"
    .include "logic/setup_entity_space.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupEntitySpace

    RTS
