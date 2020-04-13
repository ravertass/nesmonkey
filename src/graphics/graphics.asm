;;;;;;;; Graphics logic ;;;;;;;;
;; Logic related to drawing graphics goes here.

    .include "graphics/animations.asm"
    .include "graphics/entities.asm"

; SUBROUTINE
; Main subroutine for drawing entities to the screen.
; Clobbers:
;     Reg A, Reg X, Reg Y
; Side-effects:
;     Draws all entities' graphics to the screen.
UpdateGraphics:
    ; Start DMA transfer from DMA_GRAPHICS address
    LDA #LOW(DMA_GRAPHICS)
    STA $2003
    LDA #HIGH(DMA_GRAPHICS)
    STA $4014

    ; X will be the offset used to store all sprites at the correct
    ; place in memory.
    LDX #$00

    LoadEntity firstEntity

; The loop here is more or less copy-pasted from the game logic update subroutine.
.UpdateGraphicsLoop:
    ; if entity is not active: continue to next entity.
    EReadMemberToA entityActive
    BEQ .NextEntity

    JSR UpdateEntitySprites

.NextEntity:
    ; increment currentEntity pointer so we point to the next entity.
    LDA currentEntity
    CLC
    ADC #entitySize
    STA currentEntity
    LDA currentEntity+1
    ADC #$00 ; add carry to high byte of pointer
    STA currentEntity+1

    ; if we have looped through all entities: break loop.
    ComparePointer16 currentEntity, endOfEntitySpace
    BEQ .UpdateGraphicsDone

    JMP .UpdateGraphicsLoop

.UpdateGraphicsDone:
    RTS
