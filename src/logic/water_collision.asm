;;;;;;;; Game logic -- Water collisions ;;;;;;;;
;; Logic making an entity stay on land goes here.

; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; If so, it is moved in the Y direction.
; Input:
;     currentEntity
; Output:
;     currentEntity.y
; Clobbers:
;     ...
WaterCollisionY:
    RTS

; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; If so, it is moved in the X direction.
; Input:
;     currentEntity
; Output:
;     currentEntity.x
; Clobbers:
;     ...
WaterCollisionX:
    EReadMemberToA #entityDX
    BEQ .Done
    BMI .NegativeX

;PositiveX:
    JSR WaterCollision

    JMP .Done

.NegativeX:
    JSR WaterCollision

.Done:
    RTS


; SUBROUTINE ;
; Checks if the current entity collides with a water tile.
; Input:
;     currentEntity
; Output:
;     A: bitmap with bits indicating which surrounding tiles contain water.
; Clobbers:
;     ...
WaterCollision:
    LDA #$00
    STA tempVariable

;TopLeftCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    TAY

    JSR .IsWater
    BNE .TopLeftNotWater

    LDA tempVariable
    ORA #%00000001
    STA tempVariable
.TopLeftNotWater:

;TopRightCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    TAY

    JSR .IsWater
    BNE .TopRightNotWater

    LDA tempVariable
    ORA #%00000010
    STA tempVariable
.TopRightNotWater:

;BottomLeftCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    TAY

    JSR .IsWater
    BNE .BottomLeftNotWater

    LDA tempVariable
    ORA #%00000100
    STA tempVariable
.BottomLeftNotWater:

;BottomRightCorner:
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    TAX

    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    TAY

    JSR .IsWater
    BNE .BottomRightNotWater

    LDA tempVariable
    ORA #%00001000
    STA tempVariable
.BottomRightNotWater:

    LDA tempVariable
    RTS

; SUBROUTINE
; Checks if tile at X, Y (in pixel space) is a water tile.
; Input:
;     X, Y
; Output:
;     A: 0 if water,
;        >0 otherwise
; Clobbers:
;     X, tempVariable2
.IsWater:
    TXA
    LSR A
    LSR A
    LSR A
    STA tempVariable2

    TYA
    AND #%11111000
    ASL A
    ASL A

    CLC
    ADC tempVariable2

    TAX

    LDA background,X

    ; Water tile happens to be $00.
    ; Thus, we're happy with returning with the tile value
    ; in the a register.

    RTS
