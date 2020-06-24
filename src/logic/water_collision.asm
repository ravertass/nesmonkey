;;;;;;;; Game logic -- Water collisions ;;;;;;;;
;; Logic making an entity stay on land goes here.

; TODO: The subroutines in this file have become extremely costly.
;       WaterCollisionY and WaterCollisionX each takes ~1500 cycles,
;       which is far from reasonable...

;  ____ ____
; |    | ^ ^|
; |    |    |
; |   __ ^ ^|
; |__('')___|
; |  -[]-^ ^|
; |   /\    |
; |    | ^ ^|
; |____|____|
;
; We need to check four tiles:
; - x,   y
; - x+w, y
; - x,   y+h
; - x+w, y+h
;
; We find the correct tile offset using this formula:
; tile_offset = x // 8 + (y // 8)*32
;
; More CPU-appropriate math:
; a // 8 = 3 >> a
; a * 32 = a << 5
; (a // 8) * 32 = (a - a%8) * 4 = (a AND %11111000) << 2

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
    EReadMemberToA #entityDY
    BNE .CheckCollision
    RTS

.CheckCollision:
    LDY #entityX
    JSR CoordinateToPixelSpace
    STA tempX

    LDY #entityY
    JSR CoordinateToPixelSpace
    STA tempY

    EReadMemberToA #entityDY
    BMI .NegativeY

;PositiveY:
    LDA tempY ; already pointing to y + height - 1
    EAddMemberToA #entityHeight
    SEC
    SBC #$01
    STA tempY

    JSR .WaterCollisionYDim
    BNE .Done

    ; Push the entity up
    LDA tempY
    CLC
    ADC #$01
    AND #%11111000
    ESubtractMemberToA #entityHeight
    LDY #entityY
    JSR CoordinateToGameSpace

    JMP .Done

.NegativeY:
    JSR .WaterCollisionYDim
    BNE .Done

    ; Push the entity down
    LDA tempY
    CLC
    ADC #$08
    AND #%11111000
    LDY #entityY
    JSR CoordinateToGameSpace

.Done:
    RTS

; SUBROUTINE ;
; Checks if the current entity collides with a water tile on one side in the Y dimension.
; Input:
;     tempX: The entity's X coordinate.
;     tempY: The entity's Y coordinate on the side which should be checked.
.WaterCollisionYDim:
    LDA #$00
    STA tempOffset

.WaterCollisionYLoop:
    LDA tempX
    CLC
    ADC tempOffset
    TAX
    LDY tempY

    JSR IsWater
    BEQ .WaterCollisionYDone

    LDA tempOffset
    CLC
    ADC #$08
    ECompareMember #entityWidth
    BPL .WaterCollisionYLast

    STA tempOffset
    JMP .WaterCollisionYLoop

.WaterCollisionYLast:
    LDA tempX
    EAddMemberToA #entityWidth
    SEC
    SBC #$01
    TAX
    LDY tempY
    JSR IsWater
    BEQ .WaterCollisionYDone

    ; No water found
    LDA #$01

.WaterCollisionYDone:
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
    BNE .CheckCollision
    RTS

.CheckCollision:
    LDY #entityX
    JSR CoordinateToPixelSpace
    STA tempX

    LDY #entityY
    JSR CoordinateToPixelSpace
    STA tempY

    EReadMemberToA #entityDX
    BMI .NegativeX

;PositiveX:
    LDA tempX
    EAddMemberToA #entityWidth
    SEC
    SBC #$01
    STA tempX

    JSR .WaterCollisionXDim
    BNE .Done

    ; Push the entity left
    LDA tempX ; already pointing to x + width - 1
    CLC
    ADC #$01
    AND #%11111000
    ESubtractMemberToA #entityWidth
    LDY #entityX
    JSR CoordinateToGameSpace

    JMP .Done

.NegativeX:
    JSR .WaterCollisionXDim
    BNE .Done

    ; Push the entity right
    LDA tempX
    CLC
    ADC #$08
    AND #%11111000
    LDY #entityX
    JSR CoordinateToGameSpace

.Done:
    RTS

; SUBROUTINE ;
; Checks if the current entity collides with a water tile on one side in the X dimension.
; Input:
;     tempX: The entity's X coordinate on the side which should be checked.
;     tempY: The entity's Y coordinate.
.WaterCollisionXDim:
    LDA #$00
    STA tempOffset

.WaterCollisionXLoop:
    LDX tempX
    LDA tempY
    CLC
    ADC tempOffset
    TAY

    JSR IsWater
    BEQ .WaterCollisionXDone

    LDA tempOffset
    CLC
    ADC #$08
    ECompareMember #entityHeight
    BPL .WaterCollisionXLast

    STA tempOffset
    JMP .WaterCollisionXLoop

.WaterCollisionXLast:
    LDX tempX
    LDA tempY
    EAddMemberToA #entityHeight
    SEC
    SBC #$01
    TAY
    JSR IsWater
    BEQ .WaterCollisionXDone

    ; No water found
    LDA #$01

.WaterCollisionXDone:
    RTS


; SUBROUTINE
; Checks if tile at X, Y (in pixel space) is a water tile.
; Input:
;     X, Y
; Output:
;     A: 0 if water,
;        >0 otherwise
; Clobbers:
;     X, Y, tempTilePointer
IsWater:
    LDA #LOW(background)
    STA tempTilePointer
    LDA #HIGH(background)
    STA tempTilePointer+1

    ; Add the offset for the X coordinate.
    ; Only requires one byte.
    ; x offset = x_t tile coord = x // 8 = 3 >> x
    TXA ; x coord
    LSR A
    LSR A
    LSR A ; x/8 = x tile coord
    CLC
    ADC tempTilePointer
    STA tempTilePointer
    LDA #$00
    ADC tempTilePointer+1

    ; Add the offset for the Y coordinate.
    ; NOTE: Requires two bytes!
    ; y offset = (y tile coord)*32 =
    ;     (y // 8) * 32 = (y - y%8) * 4 = (y AND %11111000) << 2

    ; Y offset lower byte.
    TYA ; y coord
    AND #%11111000 ; y - y%8
    ASL A
    ASL A ; y*8 = (y tile coord)*32 = y tile offset (low)
    CLC
    ADC tempTilePointer
    STA tempTilePointer
    LDA #$00
    ADC tempTilePointer+1
    STA tempTilePointer+1

    ; Y offset higher byte.
    TYA ; y coord
    ASL A ; y*2
    LDA #$00
    ROL A ; high/2
    TAX

    TYA ; y coord
    ASL A
    ASL A ; y*4
    TXA ; high/2
    ROL A ; high
    CLC
    ADC tempTilePointer+1
    STA tempTilePointer+1

    LDX #$00
    LDA [tempTilePointer,X]

    ; Water tile happens to be $00.
    ; Thus, we're happy with returning with the tile value
    ; in the a register.

    RTS
