;;;;;;;; Game logic -- Teeth ;;;;;;;;
;; Game logic related to the teeths goes here.

; SUBROUTINE ;
UpdateTeeth:
    JSR SetMonkeyTarget
    LDA #$01
    STA followSpeed
    JSR FollowTarget

    JMP .SetDirection

    LoadOtherEntity boomerangEntity
    SwapEntities
    ECheckFlag #FLAG_IS_MOVING
    BEQ .NoBoomerang
    SwapEntities

    JSR CollisionDetect
    BEQ .KillBoomerang
    JMP .Done

.NoBoomerang:
    SwapEntities
    JMP .Done

.KillBoomerang:
    EUnsetFlag #FLAG_IS_ACTIVE

.Done:
    RTS


; SUBROUTINE ;
.SetDirection:
    EReadMemberToA entityDY
    BEQ .SetXDir
    BPL .SetDownDir
;SetUpDir
    EWriteMember entityDir, #DIR_UP
    RTS
.SetDownDir
    EWriteMember entityDir, #DIR_DOWN
    RTS

.SetXDir:
    EReadMemberToA entityDX
    BPL .SetRightDir
;SetLeftDir
    EWriteMember entityDir, #DIR_LEFT
    RTS
.SetRightDir
    EWriteMember entityDir, #DIR_RIGHT
    RTS
