sequenceDiagram
    participant Engine
    participant PlayerCameraManager
    participant View target

    Engine ->>  PlayerCameraManager: UpdateCamera()
    activate PlayerCameraManager
    PlayerCameraManager ->>+PlayerCameraManager: UpdateViewTarget()
    PlayerCameraManager ->>+PlayerCameraManager: UpdateViewTargetInternal()
    
    PlayerCameraManager ->>+View target: CalcCamera()
    note over View target: Buscar CameraComponent y calcular POV
    View target -->>-PlayerCameraManager: POV del jugador
    
    PlayerCameraManager ->> PlayerCameraManager: Modificar POV en<br/>BlueprintUpdateCamera()

    PlayerCameraManager -->>-PlayerCameraManager: Volver a UpdateViewTarget()
    note right of PlayerCameraManager: Aplicar modificadores de cámara
    PlayerCameraManager -->>-PlayerCameraManager: Volver a UpdateCamera()
    deactivate PlayerCameraManager
