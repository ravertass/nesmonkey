;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LoadEntity monkeyEntity

    EWriteMember entityActive, #$01
    EWriteMember entityType, #TYPE_MONKEY
    EWriteMember16 entityX, #$0002
    EWriteMember16 entityY, #$0002
    EWriteMember entityDX, #$00
    EWriteMember entityDY, #$00
    EWriteMember entityDir, #DIR_DOWN
    EWriteMember entityState, #IDLE
    EWriteMember entityAnimationFrame, #00
    EWriteMember entityAnimationCount, #00
    EWriteMember entityAnimationMax, #08
    EWriteMember16P entityAnimationsTable, monkeyAnimationsTable

    RTS
