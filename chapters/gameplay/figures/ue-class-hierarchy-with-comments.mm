classDiagram
    UObject <|-- UActorComponent
    UActorComponent <|-- USceneComponent
    note for USceneComponent "Puede ser ubicados\nen la escena."
    
    USceneComponent <|-- UPrimitiveComponent
    note for UPrimitiveComponent "Generan algún tipo\nde geometría como para\nrender o colisión."

    UPrimitiveComponent <|-- UStaticMeshComponent
    UPrimitiveComponent <|-- UShapeComponent
    UShapeComponent <|-- UBoxComponent
    UShapeComponent <|-- USphereComponent
    UShapeComponent <|-- UCapsuleComponent
