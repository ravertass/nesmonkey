;;;;;;;; Game setup -- Entity space ;;;;;;;;
;; Setup entity space to only contain 0x00.

; In the below subroutine, currentEntity is used as pointer
; for each byte in entity space.
SetupEntitySpace:
    LoadEntity entitySpace
    LDY #$00

.SetupEntitySpaceLoop:
    LDA #$00
    STA [currentEntity],Y

.NextByte:
    IncrementPointer currentEntity
    ; if we have looped through all of entity space: break loop.
    ComparePointer16 currentEntity, endOfEntitySpace
    BEQ .SetupEntitySpaceDone
    JMP .SetupEntitySpaceLoop

.SetupEntitySpaceDone:
    RTS
