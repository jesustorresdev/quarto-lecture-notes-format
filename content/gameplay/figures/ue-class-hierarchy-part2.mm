classDiagram    
    Actor <|-- PlayerController
    PlayerController -- EnhancedPlayerInput
    PlayerInput <|-- EnhancedPlayerInput
    
    Actor <|-- Pawn
    Pawn <|-- Character
    Character *-- CharacterMovementComponent
    Actor *-- InputComponent    

    ActorComponent <|-- InputComponent
    InputComponent <|-- EnhancedInputComponent

    ActorComponent <|-- MovementComponent

    MovementComponent <|-- NavMovementComponent
    NavMovementComponent <|-- PawnMovementComponent
    PawnMovementComponent <|-- CharacterMovementComponent
    MovementComponent <|-- ProjectileMovementComponent