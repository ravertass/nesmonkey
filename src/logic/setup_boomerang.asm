;;;;;;;; Game setup -- Boomerang ;;;;;;;;
;; Setup for the boomerang.

SetupBoomerang:
    LoadEntity boomerangEntity

    EWriteMember entityActive, #$01
    EWriteMember entityType, #TYPE_BOOMERANG
    EWriteMember16 entityX, #$0000
    EWriteMember16 entityY, #$0000
    EWriteMember16 entityDX, #$0000
    EWriteMember16 entityDY, #$0000
    EWriteMember entityDir, #DIR_DOWN
    EWriteMember entityState, #MOVING
    EWriteMember entityAnimationFrame, #00
    EWriteMember entityAnimationCount, #00
    EWriteMember entityAnimationMax, #08
    EWriteMember16 entityAnimationsTable, boomerangAnimationsTable

    RTS
