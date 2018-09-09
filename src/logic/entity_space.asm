;;;;;;;; Entity space;;;;;;;;
;; Some subroutines regarding the entity space goes here.

; Subroutine for getting a pointer to a free slot in entity space.
; If no space is free, the return value is $FFFF.
; The return value is stored in the currentEntity variable.
GetFreeEntitySlot:
    LDA #LOW(entitySpace)
    STA currentEntity
    LDY #$01
    LDA #HIGH(entitySpace)
    STA currentEntity,Y

.GetFreeEntitySlotLoop:
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
