;;;;;;;; New seagull ;;;;;;;;
;; Subroutines for adding a new seagull to entity space.

NewSeagull:
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
    EUnsetFlag #SEAGULL_FLAG_HAS_APPEARED

    EWriteMember entityType, #TYPE_SEAGULL

    JSR .GetSeagullSpeed
    EWriteAToMember entityDX
    TXA
    EWriteAToMember entityDX+1
    JSR .GetSeagullSpeed
    EWriteAToMember entityDY
    TXA
    EWriteAToMember entityDY+1

    JSR .SetSeagullDirAndPos

    EWriteMember entityWidth, #$08
    EWriteMember entityHeight, #$08
    EWriteMember entityCollisionOffset, #$00

    EWriteMember entityAnimationFrame, #$00
    EWriteMember entityAnimationCount, #$00
    EWriteMember entityAnimationMax, #$08
    EWriteMember16 entityAnimationsTable, seagullAnimationsTable

    RTS

; Writes a randomized speed to the registers.
; The higher byte in X, the lower in A.
.GetSeagullSpeed:
    ; First, randomize a small number that is not zero and transfer it to X.
    JSR RandomByte
    AND #%00000011
    CLC
    ADC #$01
    TAY

    ; Then, see if we should do negative or positive
    JSR RandomByte
    AND #%00000001
    BEQ .Positive

    ; Let's do negative!
    TYA
    NegateA
    LDX #$FF
    JMP .SpeedDone

.Positive:
    TYA
    LDX #$00
.SpeedDone:
    RTS

; TODO: Much of this subroutine could be used for all entities, really.
.SetSeagullDirAndPos:
    ; Check if DX is positive.
    EReadMemberToA entityDX+1
    AND #%10000000
    BEQ .DXPos

    ; DX is negative.
    ; Now check if DY is positive.
    EReadMemberToA entityDY+1
    AND #%10000000
    BEQ .DXNegDYPos

    ; Both DX and DY are negative.
    ; Is |dx| >= |dy|?
    EReadMemberToA entityDX
    ECompareMember entityDY
    BCC .SetLeft
    JMP .SetUp

.DXNegDYPos:
    ; Is |dx| >= |dy|?
    EReadMemberToA entityDX
    NegateA
    ECompareMember entityDY
    BCS .SetLeft
    JMP .SetDown

.DXPos:
    ; Now check if DY is positive.
    EReadMemberToA entityDY+1
    AND #%10000000
    BEQ .DXPosDYPos

    ; DX is positive, DY is negative.
    ; Is |dx| >= |dy|?
    EReadMemberToA entityDX
    NegateA
    ECompareMember entityDY
    BCC .SetRight
    JMP .SetUp

.DXPosDYPos:
    ; Is |dx| >= |dy|?
    EReadMemberToA entityDX
    ECompareMember entityDY
    BCS .SetRight
    JMP .SetDown

.SetLeft:
    EWriteMember entityDir, #DIR_LEFT
    EWriteMember16 entityX, #$03F0
    JSR .SetRandomY

    JMP .DirAndPosDone

.SetUp:
    EWriteMember entityDir, #DIR_UP
    JSR .SetRandomX
    EWriteMember16 entityY, #$0380

    JMP .DirAndPosDone

.SetDown:
    EWriteMember entityDir, #DIR_DOWN
    JSR .SetRandomX
    EWriteMember16 entityY, #$0000

    JMP .DirAndPosDone

.SetRight:
    EWriteMember entityDir, #DIR_RIGHT
    EWriteMember16 entityX, #$0000
    JSR .SetRandomY

    JMP .DirAndPosDone

.DirAndPosDone:
    RTS

; SUBROUTINE ;
.SetRandomX:
    JSR RandomByte
    AND #%00000011
    EWriteAToMember entityX+1
    CMP #$03
    BEQ .XUpperIs3
    JSR RandomByte
    JMP .XStoreLower
.XUpperIs3:
    JSR RandomByte
    AND #%01111111
    ; TODO: We would probably like larger x values,
    ;       but this is the easiest way to clamp the value.
.XStoreLower:
    EWriteAToMember entityX
    RTS

; SUBROUTINE ;
.SetRandomY:
    JSR RandomByte
    AND #%00000011
    EWriteAToMember entityY+1
    CMP #$03
    BEQ .YUpperIs3
    JSR RandomByte
    JMP .YStoreLower
.YUpperIs3:
    JSR RandomByte
    AND #%01111111
    ; TODO: We would probably like larger x values,
    ;       but this is the easiest way to clamp the value.
.YStoreLower:
    EWriteAToMember entityY
    RTS
