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
    EAddMemberToA #entityCollisionOffset
    STA tempVariable

    SwapEntities
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityWidth
    ESubtractMemberToA #entityCollisionOffset

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
    ESubtractMemberToA #entityCollisionOffset
    STA tempVariable

    SwapEntities
    LDY #entityX
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityCollisionOffset

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
    EAddMemberToA #entityCollisionOffset
    STA tempVariable

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityHeight
    ESubtractMemberToA #entityCollisionOffset

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
    ESubtractMemberToA #entityCollisionOffset
    STA tempVariable

    SwapEntities
    LDY #entityY
    JSR CoordinateToPixelSpace
    EAddMemberToA #entityCollisionOffset

    CMP tempVariable
    BMI .CollisionFound

    SwapEntities
    LDA #$01
    RTS

.CollisionFound:
    SwapEntities
    LDA #$00
    RTS
