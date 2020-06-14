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

EOrMember: .macro
    LDA \2
    LDY #\1
    ORA [currentEntity],Y
    .endm

EAndAWithMember: .macro
    LDY #\1
    AND [currentEntity],Y
    .endm

ESetFlag: .macro
    EOrMember entityFlags, \1
    EWriteAToMember entityFlags
    .endm

EUnsetFlag: .macro
    LDA \1
    EOR #$FF
    EAndAWithMember entityFlags
    EWriteAToMember entityFlags
    .endm

ECheckFlag: .macro
    EReadMemberToA entityFlags
    AND \1
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

; With carry
EAddAToMember: .macro
    LDY #\1
    ADC [currentEntity],Y
    STA [currentEntity],Y
    .endm

; Without carry
EAddMemberToA: .macro
    LDY #\1
    CLC
    ADC [currentEntity],Y
    .endm

; Signed compare with argument
ELessThan16: .macro
    SEC
    EReadMemberToA \1+1
    SBC #HIGH(\2)
    BVC .NoOverflow1\@
    EOR #$80
.NoOverflow1\@:
    BMI .IsLessThan\@
    BVC .NoOverflow2\@
    EOR #$80
.NoOverflow2\@:
    BNE .NotLessThan\@
    EReadMemberToA \1
    SBC #LOW(\2)
    BCC .IsLessThan\@
.NotLessThan\@:
    LDA #$01
    JMP .Done\@
.IsLessThan\@:
    LDA #$00
.Done\@:
    .endm

;;; Other macros

WritePointer: .macro
    LDA \2
    STA \1
    .endm

AddToPointer16: .macro
    LDA \1
    CLC
    ADC \2
    STA \1

    LDA \1+1
    ADC #$00 ; add carry to high byte of pointer
    STA \1+1
    .endm

DecrementPointer: .macro
    LDA \1
    CLC
    ADC #$FF
    STA \1
    .endm

IncrementPointer: .macro
    LDA \1
    CLC
    ADC #$01
    STA \1
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

IsPositive: .macro
    LDA \1
    AND #%10000000
    .endm

PointerIsPositive16: .macro
    IsPositive \1+1
    .endm
