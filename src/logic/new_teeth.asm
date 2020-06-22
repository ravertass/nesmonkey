;;;;;;;; Game logic - New teeth ;;;;;;;;
;; Subroutine for creating a new teeth enemy.

; SUBROUTINE ;
NewTeeth:
    JSR GetFreeEntitySlot
    LDA currentEntity+1
    CMP #$FF
    BNE .SlotAvailable

    ; No free slot found :(
    RTS

.SlotAvailable:
    EWriteMember entityFlags, #$00
    ESetFlag #FLAG_IS_ACTIVE
    ESetFlag #FLAG_IS_MOVING
    ESetFlag #FLAG_IS_VISIBLE

    EWriteMember entityType, #TYPE_TEETH
    LDA #$00
    EWriteAToMember entityDX
    EWriteAToMember entityDX+1
    EWriteAToMember entityDY
    EWriteAToMember entityDY+1

    EWriteAToMember entityX+1
    EWriteAToMember entityY+1
    LDA #$F0
    EWriteAToMember entityX
    EWriteAToMember entityY

    EWriteMember entityWidth, #$08
    EWriteMember entityHeight, #$08
    EWriteMember entityCollisionOffset, #$00

    EWriteMember entityDir, #DIR_DOWN

    EWriteMember entityAnimationFrame, #$00
    EWriteMember entityAnimationCount, #$00
    EWriteMember entityAnimationMax, #$08
    EWriteMember16 entityAnimationsTable, teethAnimationsTable

    RTS
