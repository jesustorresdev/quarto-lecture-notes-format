stateDiagram-v2
    direction LR
    [*] --> Walk
    Walk --> Jump: Jump Start
    Jump --> Walk: Land
    Jump --> DoubleJump: Jump Start\n[JumpElapsedTime < 1.5]
    DoubleJump --> Walk: Land
    Walk --> Crouch: Crouch Start
    Crouch --> Walk: Crouch End