;;;;;;;; Game setup -- Entity space ;;;;;;;;
;; Setup entity space to only contain 0x00.

; In the below subroutine, currentEntity is used as pointer
; for each byte in entity space.
SetupEntitySpace:
    LDA #LOW(entitySpace)
    STA currentEntity
    LDY #$01
    LDA #HIGH(entitySpace)
    STA currentEntity,Y

.SetupEntitySpaceLoop:
    LDA #$00
    STA [currentEntity],Y

.NextByte:
    INY
    ; if we have looped through all of entity space: break loop.
    CPY #(endOfEntitySpace - entitySpace)
    BEQ .SetupEntitySpaceDone
    JMP .SetupEntitySpaceLoop

.SetupEntitySpaceDone:
    RTS
