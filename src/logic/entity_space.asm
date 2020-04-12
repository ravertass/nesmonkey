;;;;;;;; Entity space;;;;;;;;
;; Some subroutines regarding the entity space goes here.

; SUBROUTINE
; Gets a pointer to a free slot in entity space.
; If no space is free, the return value is $FFFF.
; Output:
;     currentEntity: Free entity slot pointer
GetFreeEntitySlot:
    LoadEntity entitySpace

    ; Loop through all of entity space, until an inactive entity slot is found.
.GetFreeEntitySlotLoop:
    ; If entityActive is 0, then the entity slot is free!
    ReadMemberToA entityActive
    BEQ .GetFreeEntitySlotDone ; free slot was found!

    ; That entity was alive: let's keep looking at the next entity...

    ; increment currentEntity pointer so we point to the next entity.
    AddToPointer currentEntity, #entitySize

    ; if we have looped through all entities: break loop.
    ; we must check both the low and the high byte of the currentEntity pointer.
    LDA currentEntity
    CMP #LOW(endOfEntitySpace)
    BEQ .CompareHigh
    JMP .GetFreeEntitySlotLoop
.CompareHigh:
    ; the lower byte was equal: let's check if the higher byte is equal, too.
    LDA currentEntity+1
    CMP #HIGH(endOfEntitySpace)
    BEQ .NoFreeEntitySlot
    JMP .GetFreeEntitySlotLoop

.NoFreeEntitySlot:
    LDA #$FF
    STA currentEntity
    LDY #$01
    STA currentEntity,Y

.GetFreeEntitySlotDone:
    ; The pointer to the entity slot is in currentEntity.
    RTS
