;;;;;;;; New seagull ;;;;;;;;
;; Subroutines for adding a new seagull to entity space.

NewSeagull:
    JSR GetFreeEntitySlot
    LDA #HIGH(currentEntity)
    CMP #$FF
    BEQ .NewSeagullDone ; no free entity slot was found :(

    WriteMember entityActive, #$01
    WriteMember entityType, #TYPE_SEAGULL

    JSR RandomByte
    WriteAToMember entityX
    JSR RandomByte
    WriteAToMember entityY
    JSR RandomByte
    WriteAToMember entityX+1
    JSR RandomByte
    WriteAToMember entityY+1

    ; TODO: These should be randomized
    WriteMember entityDX, #$04
    WriteMember entityDY, #$01
    WriteMember entityDir, #DIR_RIGHT
    WriteMember entityState, #MOVING

    WriteMember entityAnimationFrame, #$00
    WriteMember entityAnimationCount, #$00
    WriteMember entityAnimationMax, #$08
    WriteMember16P entityAnimationsTable, seagullAnimationsTable

.NewSeagullDone
    RTS
