%%{init: {"flowchart" : {"curve" : "linear"}}}%%
graph TB
  Character([Character]) --> CharacterMaterials([Materials])
  Character --> CharacterMeshes([Meshes])
  Character --> CharacterTextures([Textures])

  Enemies([Enemies]) --> Tanks([Tanks])
  Enemies --> Robots([Robots])

  Tanks --> TanksMaterials([Materials])
  Tanks --> TanksMeshes([...])

  Robots --> RobotsMaterials([Materials])
  Robots --> RobotsMeshes([Meshes])
  Robots --> RobotsTextures([Textures])

  Weapons([Weapons]) --> Gun([Guns])
  Weapons --> Shotgun([Shotguns])
 
  Gun --> GunMaterials([Materials])
  Gun --> GunMeshes([...])

  Shotgun --> ShotgunMaterials([Materials])
  Shotgun --> ShotgunMeshes([...])

  style Character fill:#90EE90,stroke:green
  style Enemies fill:#FFD580,stroke:orange
  style Weapons fill:#F08080,stroke:red
