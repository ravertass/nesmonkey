    .ifndef SRC_UTIL_MACROS_
SRC_UTIL_MACROS:

;;;;;;;; Utility macros ;;;;;;;;

LoadEntity: .macro
    LDA #LOW(\1)
    STA currentEntity
    LDY #$01
    LDA #HIGH(\1)
    STA currentEntity,Y
    .endm

    .endif
