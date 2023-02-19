%%{init: {"flowchart" : {"curve" : "linear"}}}%%
graph TB
  Assets([Assets]) --> Art([Art])
  Assets --> Audio([Audio])
  Assets --> Editor([Editor])
  Assets --> Prefabs([Prefabs])
  Assets --> Scenes([Scenes])
  Assets --> Scripts([Scripts])
  Assets --> Tests([Tests])

  Art --> Materials([Materials])
  Art --> Meshes([Meshes])
  Art --> Textures([Textures])

  Materials --> CharacterMaterials([Character])
  Materials --> EnemiesMaterials([Enemies])
  EnemiesMaterials --> FinalBossMaterials([Final Boss])

  Meshes --> CharacterMeshes([Character])
  Meshes --> EnemiesMeshes([Enemies])
  EnemiesMeshes --> FinalBossMeshes([Final Boss])

  Textures --> CharacterTextures([Character])
  Textures --> EnemiesTextures([Enemies])
  EnemiesTextures --> FinalBossTextures([Final Boss])

  Audio --> CharacterAudio([Character])
  CharacterAudio --> FinalBossAudio([Final Boss])

  Scripts --> Player([Player])
  Scripts --> NPC([NPC])
  Scripts --> UI([UI])

  NPC --> FinalBossScripts([Final Boss])
