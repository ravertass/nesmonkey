;;;;;;;; Game logic - Generate enemies ;;;;;;;;
;; Logic for generating new enemies.

; SUBROUTINE ;
GenerateEnemies:
    LDA gameClock+1
    CLC
    ADC #$01
    STA tempVariable

    JSR RandomByte
    CMP tempVariable
    BCS .NoNewSeagull

    JSR NewSeagull

.NoNewSeagull:
    RTS
