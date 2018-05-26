;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LDA #$80
    STA monkeyX
    STA monkeyY
    LDA #DIR_DOWN
    STA monkeyDir
    LDA #IDLE
    STA monkeyState
    LDA #$00
    STA monkeyAnimationFrame
    LDA #$00
    STA monkeyMoveCounter

    RTS
