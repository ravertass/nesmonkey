;;;;;;;; Game logic ;;;;;;;;
;; All game logic goes here.
;; Graphics and input logic does NOT go here.

    .include "game_logic/game_logic_monkey.asm"

UpdateGame:
    JSR UpdateMonkey

    RTS
