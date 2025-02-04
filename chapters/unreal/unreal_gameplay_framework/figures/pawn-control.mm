classDiagram
    %%ÁÁÁ Fix for an encoding problem
    class Pawn {
        +AddMovementInput()
    }

    class MyPlayerPawnInterface {
        <<interface>>
        +Attack()
        +Crouch()
        +Fire()
        +Jump()
    }

    Pawn <|--  MyPlayerPawn
    MyPlayerPawnInterface <|.. MyPlayerPawn

    PlayerController <|-- MyPlayerController
    MyPlayerController ..> Pawn: posee
    MyPlayerController ..> MyPlayerPawnInterface: usa