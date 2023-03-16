classDiagram
    UObject <|-- AActor
    
    AActor <|-- APawn
    AActor <|-- ATriggerBase
    ATriggerBase <|-- ATriggerBox
    ATriggerBase <|-- ATriggerSphere
    ATriggerBase <|-- ATriggerCapsule

    AActor <|-- ABrush
    ABrush <|-- AVolume
    AVolume <|-- ATriggerVolume
    
    UObject <|-- UActorComponent

    UActorComponent <|-- USceneComponent
    UActorComponent <|-- UMovementComponent

    USceneComponent <|-- UPrimitiveComponent
    UPrimitiveComponent <|-- UShapeComponent
    UPrimitiveComponent <|-- UStaticMeshComponent
    UPrimitiveComponent <|-- UBrushComponent
    UShapeComponent <|-- UBoxComponent
    UShapeComponent <|-- USphereComponent
    UShapeComponent <|-- UCapsuleComponent