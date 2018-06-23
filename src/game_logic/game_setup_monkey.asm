;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LDA #LOW(monkeyEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(monkeyEntity)
    STA currentEntity,Y

    LDA #$80
    LDY #entityX
    STA [currentEntity],Y
    LDY #entityY
    STA [currentEntity],Y

    LDA #$01
    LDY #entityDX
    STA [currentEntity],Y
    LDY #entityDY
    STA [currentEntity],Y

    LDA #DIR_DOWN
    LDY #entityDir
    STA [currentEntity],Y

    LDA #IDLE
    LDY #entityState
    STA [currentEntity],Y

    LDA #$00
    LDY #entityAnimationFrame
    STA [currentEntity],Y

    LDA #$00
    LDY #entityAnimationCount
    STA [currentEntity],Y

    LDA #$08
    LDY #entityAnimationMax
    STA [currentEntity],Y

    LDA #LOW(monkeyAnimationsTable)
    LDY #entityAnimationsTable
    STA [currentEntity],Y
    LDA #HIGH(monkeyAnimationsTable)
    INY
    STA [currentEntity],Y

    RTS
