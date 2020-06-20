; SUBROUTINE
; Checks if currentEntity collides with otherEntity.
; Output:
;     A: 0 if collision,
;        1 otherwise
; Clobbers:
;     X, Y, tempVariable

CollisionDetect:
    ; Collision detection:
    ;
    ;  _______         ay
    ; |       |
    ; |     __|__            by
    ; |    |  |  |
    ; |____|__|  |     ay+ah
    ;      |_____|           by+bh
    ;
    ; (by+bh > ay) && (by < ay+ah) <~> !(by+bh < ay) && !(by > ay+ah)
    ;
    ; (bx+bw > ax) && (bx < ax+aw) <~> !(bx+bw < ax) && !(bx > ax+aw)

    ;;; (bx+bw > ax) ;;;

    LDY #entityX
    JSR CoordinateToPixelSpace
    STA tempVariable

    SwapEntities
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth

    CMP tempVariable
    BPL .Next1

    SwapEntities
    LDA #$01
    RTS

.Next1:
    SwapEntities

    ;;; (bx < ax+aw) ;;;

    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    STA tempVariable

    SwapEntities
    LDY #entityX
    JSR CoordinateToPixelSpace

    CMP tempVariable
    BMI .Next2

    SwapEntities
    LDA #$01
    RTS

.Next2:
    SwapEntities

    ;;; (by+bh > ay) ;;;

    LDY #entityY
    JSR CoordinateToPixelSpace
    STA tempVariable

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight

    CMP tempVariable
    BPL .Next3

    SwapEntities
    LDA #$01
    RTS

.Next3:
    SwapEntities

    ;;; (by < ay+ah) ;;;

    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    STA tempVariable

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace

    CMP tempVariable
    BMI .CollisionFound

    SwapEntities
    LDA #$01
    RTS

.CollisionFound:
    SwapEntities
    LDA #$00
    RTS
