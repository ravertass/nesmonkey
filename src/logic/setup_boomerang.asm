;;;;;;;; Game setup -- Boomerang ;;;;;;;;
;; Setup for the boomerang.

SetupBoomerang:
    LDA #LOW(boomerangEntity)
    STA currentEntity
    LDY #$01
    LDA #HIGH(boomerangEntity)
    STA currentEntity,Y

    LDA #$00
    LDY #entityActive
    STA [currentEntity],Y

    LDA #TYPE_BOOMERANG
    LDY #entityType
    STA [currentEntity],Y

    RTS
