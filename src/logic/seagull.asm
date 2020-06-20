;;;;;;;; Game logic -- Seagull ;;;;;;;;
;; Game logic related to the seagulls goes here.

; SUBROUTINE ;
UpdateSeagull:
    LoadOtherEntity boomerangEntity
    SwapEntities
    ECheckFlag #FLAG_IS_MOVING
    BEQ .NoBoomerang
    SwapEntities

    JSR CollisionDetect
    BEQ .KillSeagull
    JMP .BoomerangCheckDone

.NoBoomerang:
    SwapEntities
.BoomerangCheckDone:

    ECheckFlag #SEAGULL_FLAG_HAS_APPEARED
    BNE .SeagullAppeared

    JSR .IsWithinScreen
    BEQ .SetAppeared

    RTS

.SetAppeared:
    ESetFlag #SEAGULL_FLAG_HAS_APPEARED
    RTS

.SeagullAppeared:
    JSR .IsWithinScreen
    BNE .KillSeagull

    RTS

.KillSeagull:
    EUnsetFlag #FLAG_IS_ACTIVE
    RTS


; SUBROUTINE ;
.IsWithinScreen:
    ELessThan16 entityX, #$0000
    BEQ .IsWithinScreenFalse

    ELessThan16 entityY, #$001D
    BEQ .IsWithinScreenFalse

    ELessThan16 entityX, #$03F0
    BNE .IsWithinScreenFalse

    ELessThan16 entityY, #$0380
    BNE .IsWithinScreenFalse

;IsWithinScreenTrue:
    LDA #$00
    RTS

.IsWithinScreenFalse:
    LDA #$01
    RTS
