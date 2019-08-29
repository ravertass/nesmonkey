;;;;;;;; Entity space;;;;;;;;
;; Some subroutines regarding the entity space goes here.

; SUBROUTINE
; Gets a pointer to a free slot in entity space.
; If no space is free, the return value is $FFFF.
; Output:
;     currentEntity: Free entity slot pointer
GetFreeEntitySlot:
    LDA #LOW(entitySpace)
    STA currentEntity
    LDY #$01
    LDA #HIGH(entitySpace)
    STA currentEntity,Y

    ; Loop through all of entity space, until an inactive entity slot is found.
.GetFreeEntitySlotLoop:
    ; If entityActive is 0, then the entity slot is free!
    LDY #entityActive
    LDA [currentEntity],Y
    BEQ .GetFreeEntitySlotDone ; free slot was found!

    ; That entity was alive: let's keep look at the next entity...

    ; increment currentEntity pointer so we point to the next entity.
    LDA currentEntity
    CLC
    ADC #entitySize
    STA currentEntity
    LDY #$01
    LDA currentEntity,Y
    ADC #$00 ; add carry to high byte of pointer
    STA currentEntity,Y

    ; if we have looped through all entities: break loop.
    ; we must check both the low and the high byte of the currentEntity pointer.
    LDA currentEntity
    CMP #LOW(endOfEntitySpace)
    BEQ .CompareHigh
    JMP .GetFreeEntitySlotLoop
.CompareHigh:
    ; the lower byte was equal: let's check if the higher byte is equal, too.
    LDY #$01
    LDA currentEntity,Y
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
