;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LoadEntity monkeyEntity

    EWriteMember entityFlags, #$00
    ESetFlag #FLAG_IS_ACTIVE
    EUnsetFlag #FLAG_IS_MOVING
    ESetFlag #FLAG_IS_VISIBLE

    EWriteMember entityType, #TYPE_MONKEY
    EWriteMember16 entityX, #$0200
    EWriteMember16 entityY, #$0200
    EWriteMember16 entityDX, #$0000
    EWriteMember16 entityDY, #$0000
    EWriteMember16 entityWidth, #$08
    EWriteMember16 entityHeight, #$0A
    EWriteMember16 entityCollisionOffset, #$04
    EWriteMember entityDir, #DIR_DOWN
    EWriteMember entityAnimationFrame, #00
    EWriteMember entityAnimationCount, #00
    EWriteMember entityAnimationMax, #08
    EWriteMember16 entityAnimationsTable, monkeyAnimationsTable

    RTS
