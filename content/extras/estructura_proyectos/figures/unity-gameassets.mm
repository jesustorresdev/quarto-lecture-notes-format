%%{init: {"flowchart" : {"curve" : "linear"}}}%%
graph TB
  Assets([Assets]) --> Demigiant([Demigiant])
  Assets --> GameAssets([GameAssets])
  Assets --> OtherAssets([Other Assets])
  
  GameAssets --> Scripts([_Scripts])
  GameAssets --> Art([Art])
  GameAssets --> Audio([Audio])
  GameAssets --> Editor([Editor])
  GameAssets --> Prefabs([Prefabs])
  GameAssets --> Scenes([Scenes])
  GameAssets --> Tests([Tests])

  Art --> Materials([Materials])
  Art --> Meshes([Meshes])
  Art --> Textures([Textures])

  style GameAssets fill:#90EE90,stroke:green
