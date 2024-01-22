sequenceDiagram
    %% box Projectile
        participant DamageManager
        participant MovementController
    %% end

    participant Engine

    MovementController ->> Engine: SetActorLocation(..., Sweep=true,...)
    activate Engine
    Engine -->> DamageManager: OnActorHit(HitResult)
    Note right of DamageManager: Efectos y causar daño

    Engine -->> MovementController: HitResult
    deactivate Engine
    Note right of MovementController: Gestionar colisión al moverse

