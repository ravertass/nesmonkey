;;;;;;;; Utility macros ;;;;;;;;

;;; Entity macros

LoadEntity: .macro
    LDA #LOW(\1)
    STA currentEntity
    LDA #HIGH(\1)
    STA currentEntity+1
    .endm

EWriteAToMember: .macro
    LDY #\1
    STA [currentEntity],Y
    .endm

EWriteMember: .macro
    LDA \2
    LDY #\1
    STA [currentEntity],Y
    .endm

EWriteMember16: .macro
    EWriteMember \1, #LOW(\2)
    LDA #HIGH(\2)
    INY
    STA [currentEntity],Y
    .endm

EWriteMember16P: .macro
    EWriteMember \1, \2
    LDA \2+1
    INY
    STA [currentEntity],Y
    .endm

EReadMemberToA: .macro
    LDY #\1
    LDA [currentEntity],Y
    .endm

EReadMemberToP: .macro
    EReadMemberToA \1
    STA \2
    .endm

EReadMember16ToP: .macro
    LDY #\1
    LDA [currentEntity],Y
    STA \2
    INY
    LDA [currentEntity],Y
    STA \2+1
    .endm

; Also keeps the incremented member in A (compare with postfix ++ operator)
EIncrementMember: .macro
    EReadMemberToA \1
    CLC
    ADC #$01
    STA [currentEntity],Y
    .endm

; Compares with A
ECompareMember: .macro
    LDY #\1
    CMP [currentEntity],Y
    .endm

EAddAToMember: .macro
    LDY #\1
    ADC [currentEntity],Y
    STA [currentEntity],Y
    .endm

;;; Other macros

AddToPointer16: .macro
    LDA \1
    CLC
    ADC \2
    STA \1

    LDA \1+1
    ADC #$00 ; add carry to high byte of pointer
    STA \1+1
    .endm

IncrementPointer: .macro
    AddToPointer16 \1, #$01
    .endm

ComparePointer16: .macro
    LDA \1
    CMP #LOW(\2)
    BNE .Done\@
    ; the lower byte was equal: let's check if the higher byte is equal, too.
    LDA \1+1
    CMP #HIGH(\2)
.Done\@:
    .endm

NegateA: .macro
    EOR #$FF
    CLC
    ADC #$01
    .endm
