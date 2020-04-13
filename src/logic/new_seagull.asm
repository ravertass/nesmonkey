;;;;;;;; New seagull ;;;;;;;;
;; Subroutines for adding a new seagull to entity space.

NewSeagull:
    JSR GetFreeEntitySlot
    LDA #HIGH(currentEntity)
    CMP #$FF
    BEQ .NewSeagullDone ; no free entity slot was found :(

    EWriteMember entityActive, #$01
    EWriteMember entityType, #TYPE_SEAGULL

    JSR RandomByte
    EWriteAToMember entityX
    JSR RandomByte
    EWriteAToMember entityY
    JSR RandomByte
    EWriteAToMember entityX+1
    JSR RandomByte
    EWriteAToMember entityY+1

    ; TODO: These should be randomized
    EWriteMember entityDX, #$04
    EWriteMember entityDY, #$01
    EWriteMember entityDir, #DIR_RIGHT
    EWriteMember entityState, #MOVING

    EWriteMember entityAnimationFrame, #$00
    EWriteMember entityAnimationCount, #$00
    EWriteMember entityAnimationMax, #$08
    EWriteMember16P entityAnimationsTable, seagullAnimationsTable

.NewSeagullDone
    RTS
