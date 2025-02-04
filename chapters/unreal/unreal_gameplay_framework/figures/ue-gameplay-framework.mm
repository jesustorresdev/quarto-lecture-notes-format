classDiagram
    Actor <|-- GameMode
    Actor <|-- GameState
    Actor <|-- PlayerState
    Actor <|-- Controller
    Actor <|-- Pawn

    GameMode --> GameState
    GameState "1" --> "*" PlayerState

    PlayerController --> PlayerCameraManager
    PlayerController --> PlayerInput
    PlayerController --> HUD
    GameMode --> PlayerController : crea
    PlayerController "1" --> "1" PlayerState

    Controller <|-- PlayerController
    Controller <|-- AIController
    PlayerController --> Pawn : posee
    AIController --> Pawn : posee

    Pawn <|-- Character
    Pawn <|-- DefaultPawn
    Pawn <|-- SpectatorPawn

    ActorComponent <|-- MovementComponent
    MovementComponent <|-- CharacterMovementComponent
    Character *-- CharacterMovementComponent