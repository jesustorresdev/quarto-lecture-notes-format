sequenceDiagram
    participant Engine
    participant PCInputComponent as PlayerController InputComponent
    participant PlayerController
    participant Character
    participant CharacterMovementComponent

    PCInputComponent ->> PlayerController: "Forward" Input Action Triggered
    activate PlayerController
    PlayerController ->> Character: AddMovementInput
    Character ->> CharacterMovementComponent: AddInputVector
    CharacterMovementComponent ->> Character: Internal_AddMovementInput
    note over CharacterMovementComponent, Character: Para acumular en ControlInputVector
    deactivate PlayerController
    
    Engine ->> CharacterMovementComponent: Tick
    activate CharacterMovementComponent
    CharacterMovementComponent ->> Engine: Character.AddActorWorldOffset(FinalOffset, Sweep=true, ...)
    note over CharacterMovementComponent,Engine: Mover el personaje
    deactivate CharacterMovementComponent
