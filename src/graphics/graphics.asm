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

    JSR .ClearDmaGraphics

    ; X will be the offset used to store all sprites at the correct
    ; place in memory.
    LDX #$00

    LoadEntity endOfEntitySpace
    SubtractFromPointer16 currentEntity, #entitySize

; The loop here is more or less copy-pasted from the game logic update subroutine.
.UpdateGraphicsLoop:
    ; if entity is not active or visible: continue to next entity.
    ECheckFlag #FLAG_IS_ACTIVE
    BEQ .NextEntity
    ECheckFlag #FLAG_IS_VISIBLE
    BEQ .NextEntity

    JSR UpdateEntitySprites

.NextEntity:
    SubtractFromPointer16 currentEntity, #entitySize

    ; if we have looped through all entities: break loop.
    ComparePointer16 currentEntity, (#firstEntity-#entitySize)
    BEQ .UpdateGraphicsDone
    JMP .UpdateGraphicsLoop

.UpdateGraphicsDone:
    RTS


; SUBROUTINE
.ClearDmaGraphics:
    LoadEntity firstEntity
    LDX #$00

.ClearDmaGraphicsLoop:
    LDA #$00
    STA DMA_GRAPHICS,X
    INX
    STA DMA_GRAPHICS,X
    INX
    STA DMA_GRAPHICS,X
    INX
    STA DMA_GRAPHICS,X
    INX

    AddToPointer16 currentEntity, #entitySize

    ; if we have looped through all entities: break loop.
    ComparePointer16 currentEntity, endOfEntitySpace
    BEQ .ClearDmaGraphicsDone
    JMP .ClearDmaGraphicsLoop

.ClearDmaGraphicsDone:
    RTS
