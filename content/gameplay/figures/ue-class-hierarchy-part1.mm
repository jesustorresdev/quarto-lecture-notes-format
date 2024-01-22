classDiagram
    UObject <|-- Actor
    
    Actor <|-- Pawn
    Actor <|-- TriggerBase
    TriggerBase <|-- TriggerBox
    TriggerBase <|-- TriggerSphere
    TriggerBase <|-- TriggerCapsule

    Actor <|-- Brush
    Brush <|-- Volume
    Volume <|-- TriggerVolume
    
    UObject <|-- ActorComponent
    UObject <|-- UWorld

    ActorComponent <|-- SceneComponent
    ActorComponent <|-- MovementComponent

    SceneComponent <|-- PrimitiveComponent
    PrimitiveComponent <|-- ShapeComponent
    PrimitiveComponent <|-- StaticMeshComponent
    PrimitiveComponent <|-- BrushComponent
    ShapeComponent <|-- BoxComponent
    ShapeComponent <|-- SphereComponent
    ShapeComponent <|-- CapsuleComponent