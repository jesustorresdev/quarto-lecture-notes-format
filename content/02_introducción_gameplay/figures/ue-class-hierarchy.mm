classDiagram
    UObject <|-- AActor
    
    AActor <|-- AGameModeBase
    AGameModeBase <|-- AGameMode
    AActor <|-- APlayerController
    AActor <|-- APawn
    APawn <|-- ACharacter
    ACharacter *-- UCharacterMovementComponent
    AActor *-- UInputComponent    

    UObject <|-- UActorComponent

    UActorComponent <|-- UInputComponent
    UInputComponent <|-- UEnhancedInputComponent

    UActorComponent <|-- USceneComponent
    UActorComponent <|-- UMovementComponent

    UMovementComponent <|-- UNavMovementComponent
    UNavMovementComponent <|-- UPawnMovementComponent
    UPawnMovementComponent <|-- UCharacterMovementComponent

    USceneComponent <|-- UPrimitiveComponent
    UPrimitiveComponent <|-- UShapeComponent
    UPrimitiveComponent <|-- UStaticMeshComponent
    UShapeComponent <|-- UBoxComponent
    UShapeComponent <|-- USphereComponent
    UShapeComponent <|-- UCapsuleComponent

    UObject <|-- UPlayerInput
    UPlayerInput <|-- UEnhancedPlayerInput
    
    UObject <|-- UGameInstance