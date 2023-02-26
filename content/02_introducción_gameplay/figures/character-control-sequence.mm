sequenceDiagram
    participant ObjectInputComponent as Object InputComponent
    participant PCInputComponent as PlayerController InputComponent
    participant PlayerController
    participant Object
    participant Character

    ObjectInputComponent ->> Object: "Use" Input Action Triggered
    note over ObjectInputComponent,Object: Suponiendo que el personaje está cerca de un objeto que captura esta acción.

    PCInputComponent ->> PlayerController: "Forward" Input Action Triggered
    activate PlayerController
    PlayerController ->> Character: AddMovementInput
    deactivate PlayerController

    PCInputComponent ->> PlayerController: "Fire" Input Action Triggered
    activate PlayerController
    PlayerController ->> Character: Fire
    deactivate PlayerController

    PCInputComponent ->> PlayerController: "Jump" Input Action Pressed
    activate PlayerController
    PlayerController ->> Character: Jump
    deactivate PlayerController

    PCInputComponent ->> PlayerController: "Jump" Input Action Released
    activate PlayerController
    PlayerController ->> Character: StopJumping
    deactivate PlayerController
