;;;;;;;; Game setup ;;;;;;;;
;; Code for setting up game logic.

    .include "game_logic/game_setup_monkey.asm"

SetupGame:
    JSR SetupMonkey

    RTS
