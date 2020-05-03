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
    ; If active-flag is 0, then the entity slot is free!
    ECheckFlag #FLAG_IS_ACTIVE
    BEQ .GetFreeEntitySlotDone ; free slot was found!

    ; That entity was alive: let's keep looking at the next entity...

    ; increment currentEntity pointer so we point to the next entity.
    AddToPointer16 currentEntity, #entitySize

    ; if we have looped through all entities: break loop.
    ; we must check both the low and the high byte of the currentEntity pointer.
    ComparePointer16 currentEntity, endOfEntitySpace
    BEQ .NoFreeEntitySlot
    JMP .GetFreeEntitySlotLoop

.NoFreeEntitySlot:
    LDA #$FF
    STA currentEntity
    STA currentEntity+1

.GetFreeEntitySlotDone:
    ; The pointer to the entity slot is in currentEntity.
    RTS
