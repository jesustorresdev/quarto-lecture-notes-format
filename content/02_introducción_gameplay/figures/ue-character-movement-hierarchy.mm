%%{init: {'themeVariables': { 'fontSize': '10px'}}}%%
classDiagram
    class INavAgentInterface {
        <<interface>>
    }
    
    AController <|-- AIController

    class AIController {
        MoveToLocation()
        MoveToActor()
    }

    ActorComponent <|-- UMovementComponent
    UMovementComponent <|-- UNavMovementComponent

    class APawn {
        ControlInput: FVector
        AddMovementInput()
        Tick()
    }

    APawn <|-- ACharacter
    UNavMovementComponent <|-- UPawnMovementComponent
    UPawnMovementComponent <|-- UCharacterMovementComponent

    class UNavMovementComponent {
        NavAgentProp
        AddInputVector()
        RequestDirectMove()
        RequestPathMove()
        TickComponent()
    }

    INavAgentInterface <|.. APawn
    INavAgentInterface <|.. UNavMovementComponent

    AController --> APawn: Possess
    UCharacterMovementComponent --o ACharacter
