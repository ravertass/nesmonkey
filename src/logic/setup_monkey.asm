;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LoadEntity monkeyEntity

    EWriteMember entityActive, #$01
    EWriteMember entityType, #TYPE_MONKEY
    EWriteMember16 entityX, #$0200
    EWriteMember16 entityY, #$0200
    EWriteMember16 entityDX, #$0000
    EWriteMember16 entityDY, #$0000
    EWriteMember entityDir, #DIR_DOWN
    EWriteMember entityState, #IDLE
    EWriteMember entityAnimationFrame, #00
    EWriteMember entityAnimationCount, #00
    EWriteMember entityAnimationMax, #08
    EWriteMember16 entityAnimationsTable, monkeyAnimationsTable

    RTS
