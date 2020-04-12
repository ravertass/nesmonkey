;;;;;;;; Game setup -- Monkey ;;;;;;;;
;; Setup for the monkey.

SetupMonkey:
    LoadEntity monkeyEntity

    WriteMember entityActive, #$01
    WriteMember entityType, #TYPE_MONKEY
    WriteMember16 entityX, #$0002
    WriteMember16 entityY, #$0002
    WriteMember entityDX, #$00
    WriteMember entityDY, #$00
    WriteMember entityDir, #DIR_DOWN
    WriteMember entityState, #IDLE
    WriteMember entityAnimationFrame, #00
    WriteMember entityAnimationCount, #00
    WriteMember entityAnimationMax, #08
    WriteMember16P entityAnimationsTable, monkeyAnimationsTable

    RTS
