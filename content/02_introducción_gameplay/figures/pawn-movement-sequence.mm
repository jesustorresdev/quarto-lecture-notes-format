sequenceDiagram
    participant Engine
    participant PCInputComponent as PlayerController InputComponent
    participant PlayerController
    participant Character

    PCInputComponent ->> PlayerController: "Forward" Input Action Triggered
    activate PlayerController
    PlayerController ->> Character: AddMovementInput
    deactivate PlayerController

    PCInputComponent ->> PlayerController: "Rigth" Input Action Triggered
    activate PlayerController
    PlayerController ->> Character: AddMovementInput
    deactivate PlayerController

    Engine ->> Character: Tick
    activate Character
    Character ->> Engine: AddActorWorldOffset(FinalOffset, Sweep=true, ...)
    note over Character,Engine: Mover el personaje
    deactivate Character
