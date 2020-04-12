;;;;;;;; Utility macros ;;;;;;;;

LoadEntity: .macro
    LDA #LOW(\1)
    STA currentEntity
    LDY #$01
    LDA #HIGH(\1)
    STA currentEntity,Y
    .endm
