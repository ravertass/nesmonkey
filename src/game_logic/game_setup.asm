;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "game_logic/game_setup_monkey.asm"
    .include "game_logic/game_setup_entity_space.asm"

SetupGame:
    JSR SetupMonkey
    JSR SetupEntitySpace

    RTS
