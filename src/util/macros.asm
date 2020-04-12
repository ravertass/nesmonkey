;;;;;;;; Utility macros ;;;;;;;;

;;; Entity macros

LoadEntity: .macro
    LDA #LOW(\1)
    STA currentEntity
    LDY #$01
    LDA #HIGH(\1)
    STA currentEntity,Y
    .endm

WriteMember: .macro
    LDA \2
    LDY #\1
    STA [currentEntity],Y
    .endm

WriteMember16: .macro
    WriteMember \1, LOW(\2)
    LDA HIGH(\2)
    INY
    STA [currentEntity],Y
    .endm

WriteMember16P: .macro
    WriteMember \1, #LOW(\2)
    LDA #HIGH(\2)
    INY
    STA [currentEntity],Y
    .endm

ReadMemberToA: .macro
    LDY #\1
    LDA [currentEntity],Y
    .endm

ReadMemberToP: .macro
    ReadMemberToA \1
    STA \2
    .endm

ReadMember16ToP: .macro
    LDY #\1
    LDA [currentEntity],Y
    STA \2
    INY
    LDA [currentEntity],Y
    STA \2+1
    .endm

; Also keeps the incremented member in A (compare with postfix ++ operator)
IncrementMember: .macro
    ReadMemberToA \1
    CLC
    ADC #$01
    STA [currentEntity],Y
    .endm

; Compares with A
CompareMember: .macro
    LDY #\1
    CMP [currentEntity],Y
    .endm

AddAToMember: .macro
    LDY #\1
    ADC [currentEntity],Y
    STA [currentEntity],Y
    .endm

;;; Other macros

AddToPointer: .macro
    LDA \1
    CLC
    ADC \2
    STA \1

    LDA \1+1
    ADC #$00 ; add carry to high byte of pointer
    STA \1+1
    .endm
