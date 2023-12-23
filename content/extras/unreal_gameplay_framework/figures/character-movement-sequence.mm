sequenceDiagram
    participant Engine
    participant PlayerController
    participant Character
    participant CharacterMovementComponent

    activate PlayerController
    PlayerController ->> Character: AddMovementInput
    Character ->> CharacterMovementComponent: AddInputVector
    CharacterMovementComponent ->> Character: Internal_AddMovementInput
    note over CharacterMovementComponent, Character: Acumular en ControlInputVector
    deactivate PlayerController

    Engine ->> CharacterMovementComponent: Tick
    activate CharacterMovementComponent
    CharacterMovementComponent ->> Character: ConsumeMovementInputVector()
    CharacterMovementComponent ->> Character: AddActorWorldOffset(FinalOffset, Sweep=true, ...)
    note over CharacterMovementComponent, Character: Mover el personaje
    deactivate CharacterMovementComponent