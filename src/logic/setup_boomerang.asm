;;;;;;;; Game setup -- Boomerang ;;;;;;;;
;; Setup for the boomerang.

SetupBoomerang:
    LoadEntity boomerangEntity

    EWriteMember entityFlags, #$00
    ESetFlag #FLAG_IS_ACTIVE
    EUnsetFlag #FLAG_IS_MOVING
    ; By not setting FLAG_IS_MOVING, we say that the boomerang is idle.

    EWriteMember entityType, #TYPE_BOOMERANG
    EWriteMember16 entityX, #$0000
    EWriteMember16 entityY, #$0000
    EWriteMember16 entityDX, #$0000
    EWriteMember16 entityDY, #$0000
    EWriteMember16 entityWidth, #$08
    EWriteMember16 entityHeight, #$08
    EWriteMember16 entityCollisionOffset, #$00
    EWriteMember entityDir, #DIR_DOWN
    EWriteMember entityAnimationFrame, #00
    EWriteMember entityAnimationCount, #00
    EWriteMember entityAnimationMax, #08
    EWriteMember16 entityAnimationsTable, boomerangAnimationsTable

    RTS
