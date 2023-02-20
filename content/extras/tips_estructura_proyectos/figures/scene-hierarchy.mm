%%{init: {"flowchart" : {"curve" : "linear"}}}%%
graph TB
  Scene([Scene]) --> MainCamera([Main Camera])
  Scene --> Enemy01([Enemy01])
  Scene --> Enemy02([Enemy02])
  Scene --> Enemy03([Enemy03])
  Scene --> Environment([Environment])
  Scene --> Player([Player])
  Scene --> Vehicle01([Vehicle01])
  Scene --> Vehicle02([Vehicle02])

  Environment --> Buildings([Buildings])
  Environment --> Lights([Lights])
  Environment --> Roads([Roads])
  Environment --> Props([Props])
