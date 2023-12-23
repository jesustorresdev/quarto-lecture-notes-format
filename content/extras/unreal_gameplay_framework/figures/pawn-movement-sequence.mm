sequenceDiagram
    participant Engine
    participant PlayerController
    participant Pawn
    participant MovementComponent

    activate PlayerController
    PlayerController ->> Pawn: AddMovementInput
    note over Pawn: Acumular en ControlInputVector
    deactivate PlayerController

    Engine ->> MovementComponent: Tick
    activate MovementComponent
    MovementComponent ->> Pawn: ConsumeMovementInputVector()
    MovementComponent ->> Pawn: AddActorWorldOffset(FinalOffset, Sweep=true, ...)
    note over MovementComponent, Pawn: Mover el personaje
    deactivate MovementComponent
