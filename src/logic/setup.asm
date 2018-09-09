;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "logic/setup_monkey.asm"
    .include "logic/setup_entity_space.asm"
    .include "logic/new_seagull.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupEntitySpace
    JSR NewSeagull ; TODO: Seagulls should be added dynamically.

    RTS
