::: {.informalexample}
**Tiempo de lectura:** 1 hora y 2 minutos
:::

Aunque en los videojuegos se suele hacer mucho hincapié en la calidad del *render*, en un buen motor de videojuegos hay otro componente igual de importante para dotar de realismo al mundo del juego: el motor de físicas.

# Introducción a los motores de físicas {#_introducción_a_los_motores_de_físicas}

El motor de físicas es un componente desarrollado para realizar simulaciones de la dinámica de sistemas físicos con el objeto de modelar el mundo real.

Pero hay que tener en cuenta que por las limitaciones impuestas por el tiempo real, los motores utilizados en videojuegos generalmente solo simulan sistemas relativamente simples y lo hacen de forma aproximada, lo que puede generar todo tipo de problemas inesperados. Excepto en juegos con puzles donde el comportamiento físico es un factor determinante, en general solo hace falta que para el jugador la simulación sea lo suficientemente convincente. De hecho es común evitar usarla todo lo posible, empleándola más bien como efecto visual.

## Tipos de simulaciones {#_tipos_de_simulaciones}

Los motores de físicas actuales suelen soportar diferentes tipos de simulaciones para diferentes tipos de objetos.

### Dinámica de sólido rígido {#_dinámica_de_sólido_rígido}

La simulación de la dinámica de sólido rígido es la responsable de la simulación de la acción de fuerzas y colisiones en cuerpos no deformables. Es el tipo de simulación más sencilla y rápida de calcular y el primer tipo de simulación que se soportó en los motores de físicas para videojuegos.

Para este tipo de simulación, generalmente se le proporciona al motor una versión simplificada de la malla del objeto, que se usa para detectar colisiones. Mientras que para simular la dinámica de los cuerpos cuando hay colisiones o se aplican fuerzas mediante código, los motores suelen implementar alguna versión del método Gauss-Siedel[\[1\]](#Wikipedia-Gauss-Seidel).

Una optimización común es que los objetos que permanecen detenidos durante cierto tiempo son sacados temporalmente de la simulación, aunque no de la detección de colisiones, hasta que son perturbados de nuevo.

### Dinámica de cuerpos blandos {#_dinámica_de_cuerpos_blandos}

Este tipo de simulación es usada con objetos blandos, tejidos y líquidos.

Los objetos blandos se pueden modelar como varios cuerpos rígidos, conectados de tal forma que unos cuerpos están unidos a otros. Usando estos cuerpos como el esqueleto de una malla, se puede obtener una superficie para el *rendering* mediante animación esqueletal.

Los tejidos se suelen modelar en el motor de físicas mediante partículas entre las que se establecen restricciones que confinan su movimiento mediante parámetros de estiramiento y flexión, entre otros. Esta técnica basada en partículas también se puede usar para simular objetos blandos y fluidos.

Sin embargo, la técnica que ofrece más precisión son los sistemas basados en elementos finitos[\[2\]](#Wikipedia-Elementos-Finitos). En ella la malla del objeto se descompone en elementos más pequeños conectados mediante nodos. Los nodos representan los puntos donde se van a calcular desplazamientos del objeto. Mientras que los elementos están determinados por conjuntos de nodos y representan aspectos de las propiedades físicas del objeto, como la plasticidad y la rigidez.

![Esquema de un modelo basado en elementos finitos.](media/diag-18552c6e7c710dde5409884d2dc00336.png)

Sobre el modelo de elementos finitos se hacen los cálculos considerando el estrés al que las fuerzas involucradas someten a la estructura. El resultado permite simular con gran realismo deformaciones, destrucciones y otros efectos físicos en todo tipo de materiales.

En el [???](#video-dmm) se puede ver un ejemplo de este efecto de deformación obtenido mediante elementos finitos con el motor «Digital Molecular Matter».

Lamentablemente, las técnicas basadas en elementos finitos en tiempo real son extremadamente costosas, por lo que su uso no está muy extendido.

### Sistemas de partículas {#_sistemas_de_partículas}

Los sistemas de partículas son utilizados para simular humo, fuego, explosiones, agua en movimiento o efectos visuales.

Estos sistemas tienen un emisor que lanza partículas con una serie de propiedades preconfiguradas. A cada partícula se le pueden aplicar las reglas de la simulación de la dinámica de sólido rígido, por lo que también se pueden utilizar para simular objetos de pequeño tamaño en movimiento. Obviamente, el número de partículas viene limitado por la capacidad del hardware para simular una gran cantidad de estos objetos al mismo tiempo.

### Ragdoll {#_ragdoll}

Es una técnica utilizada para animar el movimiento de los personajes cuando mueren. Trata el cuerpo del personaje como una serie de cuerpos rígidos conectados y simula lo que ocurre cuando el cuerpo del personaje colapsa al caer inanimado.

### Ray casting {#_ray_casting}

Aparte de detectar colisiones entre cuerpos y de simular su dinámica, los motores de físicas permiten «consultar» la geometría del nivel. Para ello ofrece funciones para obtener los objetos dentro de cierta región o emitir «rayos» desde cualquier punto del espacio y obtener los objetos interceptados en su recorrido.

Esto puede ser útil para predecir la colisión de proyectiles y armas, detectar amigos, enemigos o recursos cercanos o determinar la distancia al suelo o a otras superficies, entre muchos otros usos.

## Motores de física {#_motores_de_física}

El motor de físicas representa una parte importante del código de cualquier motor de videojuegos y programarlo no es sencillo. Por suerte, en la actualidad hay un buen número de librerías y los motores de videojuegos existentes suelen integrar alguna de ellas.

### ODE {#_ode}

ODE[\[3\]](#ODE) es un motor libre ---disponible en licencia dual LGPL/BSD--- que soporta detección de colisiones y dinámica de sólidos rígidos.

### Bullet {#_bullet}

Bullet[\[4\]](#Bullet) es un motor libre ---disponible bajo licencia Zlib--- utilizado tanto en producciones cinematográficas como en videojuegos. Es el motor incluido en Godot y en el motor de videojuegos de Blender y se ha usado en Grand Theft Auto IV (2008), Grand Theft Auto V (2023), Rocket League (2015) y Persona 5 (2016), entre otros.

Aparte de las características de detección de colisiones y dinámica de sólidos rígidos, soporta también dinámica de cuerpos blandos y detección continua de colisión ---o *Continuous Collision Detection* (CCD), en inglés---. Esta técnica es muy útil cuando en la simulación hay objetos muy pequeños que se mueven muy rápido, como veremos más adelante.

### PhysX {#_physx}

PhysX[\[5\]](#PhysX) probablemente es el motor de físicas más popular. Es un motor libre con licencia BSD-3 que ha sido usado en The Witcher 3 (2015), Fallout 4 (2015), Batman: Arkham Knight (2015) y Borderlands 2 (2012), entre muchos otros. Además, es el motor integrado en Unreal Engine 4 y Unity, entre otros motores, lo que justifica su gran popularidad.

PhysX fue adquirido por NVIDIA con el propósito de ofrecer un motor que pudiera acelerarse usando la GPU de sus tarjetas gráficas Geforce. Sin embargo, puede ejecutarse además en cualquier CPU y está disponible para Windows, Linux, Mac, PS4, Xbox One, Nintendo Switch, IOS y Android.

Aparte de las características básicas de simulación de la dinámica de sólidos rígidos, PhysX también soporta detección continua de colisión. Además, NVIDIA ofrece una colección de librerías adicionales con las que ampliar los tipos de simulaciones soportadas: destrucciones, ropa, líquidos, fuego y humo. Y para PhysX 5.0 se ha anunciado el soporte de modelos basados en elementos finitos.

### Chaos Physics {#_chaos_physics}

Chaos Physics[\[6\]](#Chaos) es un nuevo motor de físicas desarrollado por Epic Games expresamente para Unreal Engine 5, siendo el motor por defecto en Unreal Engine desde la primera *release* estable 5.0. Opcionalmente se puede utilizar PhysX con Unreal Engine 5, aunque con toda seguridad esta posibilidad desaparecerá en alguna versión futura.

Chaos soporta simulación de la dinámica de sólidos rígidos, tejidos y vehículos. E incluye un potente sistema para simular la destrucción de objetos en tiempo real, llamado Chaos Destruction.

### Havok {#_havok}

Havok[\[7\]](#Havok) es un producto comercial y es el estándar *de facto* de la industria en juegos AAA, proporcionando una solución muy robusta, optimizada ---especialmente en mundos muy grandes--- y con el mayor conjunto de características.

En el [???](#video-unity-physics-vs-havok) se pueden ver las diferencias en cuanto a simulación entre Havok y el motor de físicas de Unity, basado en PhysX.

Havok está disponible en Unity gratuitamente en versión *preview* solo para proyectos que usan DOTS[\[8\]](#Unity-Havok). En el futuro tendrá cierto coste para aquellos usuarios con licencia Unity Pro[\[9\]](#Unity-Havok-Prices). Unreal Engine es un poco más complejo, ya que es necesario adquirir el SDK que incluye un *plugin* para dicho motor.

### Digital Molecular Matter (DMM) {#_digital_molecular_matter_dmm}

Digital Molecular Matter (DMM)[\[10\]](#DMM) es un motor de físicas único en tanto en cuanto usa elementos finitos para simular la dinámica de cuerpos deformables y rompibles.

Un ejemplo de lo que puede hacer se puede ver en el videojuego Star Wars: The Force Unleashed (2008). En el [???](#video-dmm) se muestra una escena bastante conocida de dicho juego en la que el protagonista aplasta un AT-ST con La Fuerza.

## GPU y procesadores de uso específicos {#_gpu_y_procesadores_de_uso_específicos}

Años atrás, se trabajó sobre la idea de que las simulaciones físicas se ejecutarían en un procesador especializado ---como estaba pasando con los gráficos--- descargando de ese trabajo a la CPU y proporcionando simulaciones realistas, como no se habían visto hasta entonces.

Con esa idea, por ejemplo, NovodeX creó sus procesadores PhysX y el PhysX SDK. Posteriormente, la empresa fue adquirida por AGEIA, que fabricó tarjetas de expansión con ese chip en formato PCIe. Finalmente, AGEIA fue adquirida por NVIDIA, que adaptó PhysX para que funcionara sobre sus GPU y durante mucho tiempo promocionó el soporte mejorado de PhysX como una ventaja de sus tarjetas.

En la actualidad, el motor de físicas se ejecuta en la CPU, incluso en los motores de videojuegos que usan PhysX. A fin de cuentas, es mucho más conveniente reservar la potencia de GPU para los gráficos.

## Motor de física determinista {#_motor_de_física_determinista}

Debido a que los motores de físicas están diseñados para ofrecer soluciones aproximadas en tiempo real, por lo general no son deterministas. Esto quiere decir que en las mismas circunstancias, no generan siempre la misma simulación.

Esto no suele ser un problema, excepto en algunos tipos de juegos en red donde se opta por enviar las acciones de cada usuario a los clientes, para que estos actualicen con esa información el estado local del juego. En estas circunstancias, para que todos los jugadores vean lo mismo, la simulación física en cada uno de los clientes debería ser exactamente igual, apareciendo la necesidad de tener un motor con física determinista.

En los juegos en red, cuando se tiene que utilizar un motor de físicas no determinista, es importante asegurar que los efectos físicos no afecten al *gameplay*. Es decir, solo deben usarse con fines cosméticos, de forma que no importe que puedan ser diferentes en cada cliente. Si alguna simulación tiene efecto en el *gameplay* se debe valorar implementarla de otra manera, por ejemplo, simulado directamente las ecuaciones cinemáticas, cuyos resultados se puede ir sincronizando periódicamente a través de la red.

Actualmente, Havok ofrece física determinista entre clientes que se ejecutan en la misma arquitectura de CPU. Mientras que Unity se ha propuesto que su nuevo Unity Physics para DOTS sea determinista incluso entre plataformas diferentes[\[11\]](#Unity-Physics-Engine).

# Colisiones {#_colisiones}

Para detectar colisiones los motores de físicas necesitan una versión simplificada de la malla del objeto. Por eso los motores proporcionan una serie de componentes con los que describir esa geometría.

## Colliders {#_colliders}

En un Unreal Engine están: **BoxComponent**, **SphereComponent** y **CapsuleComponent**, que tienen la forma que su propio nombre indica. Mientras que en Unity se llaman *colliders* y tienen exactamente las mismas formas que los de Unreal: **BoxCollidder**, **SphereCollider** y **CapsuleCollider**.

Estas similitudes son naturales. Tanto Unity como Unreal Engine 4 utilizan el motor PhysX.

## Colliders complejos {#_colliders_complejos}

Cuando esas formas tan simples no son suficientes, se puede optar por crear la geometría para el motor de físicas a partir de la propia malla del objeto.

En Unity se hace añadiendo el componente **MeshCollider**, que usa el componente **Mesh** del mismo *GameObject* para obtener la malla y calcular una forma que encaje perfectamente con ella. Sin embargo esto tiene varios inconvenientes:

-   El motor es incapaz de detectar colisiones entre dos *mesh collider*, que pueden tener una geometría muy completa.

-   No se pueden utilizar en *GameObject* con un componente **RigidBody**, ya que PhysX necesita almacenar la velocidad y otra información en cada vértice del *collider* y esto es muy caro para este tipo de geometría.

Ambos inconvenientes se pueden sortear activando la propiedad **Convex** del **MeshCollider** que genera un *collider* convexo con un máximo de 255 triángulos.

::: {.note}
Que la geometría sea convexa implica que envuelve completamente al objeto, de tal forma que la línea que une dos puntos cualquiera del objeto está completamente dentro de la geometría[\[12\]](#Convexidad)
:::

Como comentaremos más adelante, Unreal Engine genera automáticamente para cada malla una geometría de colisión compleja ---equivalente a lo que hace **MeshCollider** en Unity--- que se ajusta perfectamente a ella. Esta se puede utilizar para la detección de colisión, pero en realidad se crea con otro fin. Para la detección de colisiones lo conveniente es añadir una geometría convexa, con diferentes grados de complejidad, que se ajuste mejor a las mallas que las formas primitivas que hemos comentado.

## Vehículos {#_vehículos}

La física de los vehículos es lo bastante compleja como para que el motor de físicas traiga componentes específicos que contemplen aspectos tales como la física de las ruedas, la suspensión y la fricción de los neumáticos[\[13\]](#NVIDIA-PhysX-Vehicles).

A este respecto, Unity proporciona un componente [WheelCollider](https://docs.unity3d.com/Manual/class-WheelCollider.html), para colocar en cada una de las ruedas del vehículo. En cada uno de estos *colliders* se pueden configurar propiedades como la fricción de los neumáticos y la suspensión, al tiempo que permite controlar cada una de las ruedas independientemente indicando su ángulo de dirección y el torque aplicado. Unity ofrece un tutorial muy completo donde se detalla cómo usarlo e incluye algunos consejos[\[14\]](#Unity-WheelCollider-Tutorial).

En Unreal Engine se puede trabajar de forma similar mediante un componente denominado **SimpleWheeledVehicleMovement**. Este permite aplicar individualmente a cada rueda los ángulos de dirección y torque, para mover y frenar el vehículo. Cada rueda debe heredar de la clase **VehicleWheel**, dónde se configuran sus propiedades[\[15\]](#UE-SimpleWheeledVehicleMovement).

Además, Unreal Engine ofrece otra alternativa algo más compleja mediante el componente **WheeledVehicleMovementComponent**. Este también necesitas ruedas heredadas de la clase **VehicleWheel**, pero estas no se controlan directamente, sino que se le indica a **WheeledVehicleMovementComponent** la entrada de dirección y aceleración del vehículo Entonces el componente determina cómo debe actuar sobre las ruedas mediante una simulación del tren motriz del vehículo[\[16\]](#UE-Vehicle-User-Guide).

Hay que tener en cuenta que, por lo general, los componentes incluidos con los motores no están pensados para ofrecer una simulación de conducción realista, sino para conducción «tipo arcade». Para tener una simulación realista y precisa de la dinámica de un vehículo, tendremos que implementar nuestra propia solución.

## Capas y canales {#_capas_y_canales}

Generalmente no es interesante que todos los objetos puedan colisionar o interactuar con todos los demás objetos de la escena. Por eso los motores permiten colocar los *colliders* en distintas categorías o capas, para así controlar con qué otros *colliders* pueden colisionar. También sirve para filtrar los objetos que interesan al hacer consultas mediante *ray casting*.

Por ejemplo, un vehículo puede usar varios *colliders* en capas diferentes. Uno más o menos detallado para detectar con precisión el punto de colisión de los proyectiles y otra cápsula más básica para la interacción con otros objetos de la escena mientras se desplaza. Al mismo tiempo los proyectiles pueden tener efecto sobre los enemigos pero sobre otros objetos de la escena.

Unity utiliza un sistema muy flexible de capas:

-   Admite hasta 32 capas. Las 8 primeras ya vienen preparadas y se pueden crear 24 más.

-   Cada *GameObject* puede pertenecer a una de ellas.

-   En las propiedades cada capa se configura con qué otras capas pueden colisionar sus *GameObject*. De igual forma, al hacer *ray casting* se puede indicar de qué capas son los objetos que nos interesan.

![Matriz de colisión entre capas en Unity.](media/unity-layer-collision-matrix.png)

Unreal Engine tiene un concepto similar, aunque usa el término de canales:

-   Trae algunas canales preestablecidos y permite crear hasta 18 más.

-   Los canales se separan entre aquellos usados para *ray casting* ---o *trace channels*--- y aquellos usados en la interacción entre objetos de la escena -o *object channels*---.

-   Cada componente debe pertenecer a un canal de objeto.

-   En las propiedades de cada canal se indica el tipo de interacción por defecto de sus objetos con otros canales, pero en cada componente se puede alterar este comportamiento de forma particular.

![Configuración de colisión de un objeto con los diferentes canales.](media/ue-collision-presets.png)

En Unreal Engine también se pueden alterar los parámetros de colisión en las propiedades de los actores, no solo en cada uno de los componentes dentro del actor. Estas propiedades de colisión del actor son realmente las de su componente raíz.

# Colisiones, *triggers* y cinemáticos {#_colisiones_triggers_y_cinemáticos}

El motor de físicas maneja dos conceptos de forma independiente:

-   **Colisión**. Es el mecanismo por el cual detecta colisiones entre las entidades conocidas, permitiendo que cuando eso ocurra, unas entidades bloqueen a otras su movimiento. Para esto es para lo que se le coloca al objeto una cápsula o algún otro tipo de *collider*.

-   **Simulación física**. Es el mecanismo por el cual el motor de físicas simula el comportamiento físico de las entidades, teniendo en cuenta colisiones y fuerzas aplicadas. El motor de físicas toma el control del movimiento de las entidades para actualizarlo con los resultados de la simulación.

    Para esto es para lo que se coloca en Unity a un objeto el componente **RigidBody** o en Unreal Engine se activa la propiedad **Simulate Physics**.

::: {.note}
En ambos caso el efecto en PhysX es el mismo: crear un objeto `PxRigidBody` que representará al cuerpo rígido del objeto en motor de físicas durante la simulación.
:::

Los objetos con física tienen ambas cosas. Es decir, tienen una geometría que sirve al motor de físicas para saber cuándo colisionan y, además, su movimiento está controlado por el motor.

::: {.note}
En Unreal Engine, en los *presets* de colisión, se puede indicar si la geometría de colisión se va a utilizar en simulación física, para *query* ---es decir, para *raycasts* y traslaciones en modo *barrido*, con detección de colisiones y *overlaps*, pero sin simulación física--- para ambos casos o no se va a utilizar en absoluto.

El motivo para usar esta opción es que se puede obtener cierta mejora de rendimiento excluyendo datos que no van a ser necesarios en la simulación física o en las *queries*. Para poder activar la simulación física, el componente o el *asset* debe tener activada la colisiones con ese fin. En la [figure\_title](#fig-collision-presets) se puede observar esta opción bajo el nombre de **Collision Enabled**.
:::

Los objetos con la simulación física activada no respetan la transformación relativa respecto al objeto padre, puesto que su transformación en el espacio y su movimiento son determinados libremente por el motor de físicas. Es decir, un objeto puede estar unido a un objeto padre según cierta transformación relativa, pero si el hijo tiene activada la simulación física, es como si no estuviera padre. Sin embargo, si este, a su vez, tiene hijos, todos los objetos hijos que no tengan activa la simulación física se moverán con él, respetando sus transformaciones relativas.

## Cinemáticos {#_cinemáticos}

También es posible tener objetos con detección de colisión pero sin simulación. Esos objetos se llaman **cinemáticos** y lo que nos permite es moverlos libremente por la escena, al tiempo que pueden colisionar con otros objetos físicos o cinemáticos. En una colisión, el movimiento del objeto cinemático no se ve alterado, ya que no responde a la simulación física.

En Unreal Engine se crean objetos cinemáticos desactivando la propiedad **Simulate Physics** en **Physics** o usando el bloque de *blueprint* **Set Simulate Physics**. En Unity son objetos cinemáticos aquellos con la propiedad **Is Kinematic** del componente **RigidBody** a verdadero.

## Triggers {#_triggers}

A veces, las geometrías físicas no nos interesan para detectar colisiones, sino como volúmenes en los que queremos detectar cuándo entra o sale otro objeto. De hecho, gran parte del *gameplay* de cualquier nivel se desarrolla a base de poner estas regiones y hacer que se lancen las acciones adecuadas al entrar en ellas.

Este comportamiento se puede indicar señalando que la geometría es un *trigger*, de tal forma que el motor de físicas la ignore y no la tenga en cuenta en la detección de colisiones.

Para eso los *colliders* de Unity tienen la propiedad **Is Trigger**. En Unreal Engine el comportamiento en cada componente se puede fijar basándose en el tipo de objeto que es el otro componente. Simplemente hay que marcar en la propiedad **Collision Response** de **Collision** con qué canales se quiere el *overlap* en lugar del *block*.

![Configurar en Unreal Engine el componente para hacer de *trigger* con objetos del canal **WoldDynamic**.](media/col_overlap_event_sphere.png)

## Eventos {#_eventos}

Los motores pueden informar al código tanto de colisiones como de eventos de *trigger*, según el modo que se esté usando.

// TODO: Comprobar con bSweep.

En Unreal los eventos de colisión se emiten si está activa la propiedad **Simulation Generates Hit Events** en la sección **Collision**. Mientras que para los eventos de *trigger* tiene que estar activa la propiedad **Generate Overlap Events**. Sin embargo, no se recomienda que en un mismo actor se activen ambos tipos de eventos, ya que, por ejemplo, la colisión de un objeto muy rápido contra otro puede generar un evento de *overlap*, aunque estén configurados para bloquearse.

::: {.note}
Esto es debido a que por la forma en la que se implementa la detección de colisiones, un objeto que se desplace muy rápido puede penetrar levemente en el otro, aunque estén configurados para bloquearse. Si **Generate Overlap Events** está activo, este hecho hará que se emita un evento de *overlap*.
:::

En Unity reciben evento de colisión los objetos con componente **RigidBody**. Eso significa que los objetos estáticos ---que se verán en el siguiente apartado--- no pueden recibir este tipo de eventos por no tener **RigidBody**. Mientras que reciben evento de *trigger* los objetos con un *collider* en modo *trigger*.

En la documentación de Unity hay una tabla donde se indica cuándo se emiten eventos en función del tipo de objetos que colisionan[\[17\]](#Unity-Colliders-Overview).

## Múltiples geometrías de colisión {#_múltiples_geometrías_de_colisión}

¿Qué ocurre si un *GameObject* o un actor tienen varias cápsulas u otro tipo de geometría de colisión?

En Unity un **GameObject** con varios *colliders* ---ya sea en el mismo objeto o en objetos hijos--- se comportan como uno solo desde el punto de vista de la detección de colisiones. Si el **GameObject** tiene un **RigidBody** emitirá a sus *scripts* los eventos correspondientes, incluso aunque la colisión involucre a *colliders* en objetos hijos.

En Unreal Engine las cosas son un poco más complicadas. Cuando se añaden varias geometrías de colisión en un *asset* **StaticMesh**, estos se comportan como un único componente compuesto para el **StaticMeshComponent** donde se asigna el *asset*. Sin embargo, no ocurre así cuando un actor tiene varios actores con distintos *colliders*.

Dentro de un actor se pueden añadir múltiples componentes con *colliders*. Estos son todos los que tiene clases que heredan de **PrimitiveComponent**, como **StaticMeshComponent** o cualquiera de los **CollisionComponent**. Todos estos componentes se pueden mover, obtener eventos para cada uno y activar la simulación física individualmente, pero no se consideran los *colliders* en componentes hijos al mover todo el actor. Al nivel de actor, solo se consideran las colisiones, eventos y simulación física del componente raíz. El resto de componentes del actor son teletransportados automáticamente a la posición de destino.

Los actores que se trasladan por la escena ---como personajes y proyectiles--- pueden tener un componente **MovementComponent** responsable del movimiento. Por defecto, este componente solo considera las colisiones del componente raíz del actor. Con el método **SetUpdatedComponent** se puede indicar al **MovementComponent** otro componente del actor para mover y, por tanto, será ese del que se comprueben las colisiones durante el movimiento.

# Objetos estáticos frente a dinámicos {#_objetos_estáticos_frente_a_dinámicos}

Desde el punto del motor de física, los objetos de una escena pueden ser estáticos o dinámicos.

-   Los **objetos estáticos** nunca se mueven. Se usan para definir la geometría de la escena, que siempre es la misma. Se puede colisionar con ellos, pero nunca se moverán del sitio.

-   Los **objetos dinámicos** se mueven. Al contrario que los objetos estáticos, estos no solo pueden colisionar sino que el motor de físicas cambia su movimiento según las colisiones sufridas o según las fuerzas aplicadas mediante código.

Lo importante es que el motor de físicas realiza ciertas optimizaciones, sabiendo que los objetos estáticos no se mueven ni cambian de tamaño ni van a aparecer o desaparecer. Por lo tanto, si se altera de alguna forma un objeto estático, se obliga al motor de física a rehacer ciertos cálculos internos, afectando al rendimiento del juego.

En Unity son objetos estáticos todos aquellos que tengan un *collider* pero no un **RigidBody**, porque son los objetos con los que el motor de físicas puede detectar colisiones, pero no los puede mover. Sin embargo, se debe tener cuidado, puesto que los podemos mover de otras maneras.

En Unreal Engine son objetos estáticos aquellos cuya propiedad **Mobility** de la sección **Transform** no está marcada como **Movable**. Afortunadamente, Unreal Engine no permite mover de ninguna forma actores que no son **Movable**, de forma parecida al efecto que tiene la propiedad **Static** de Unity.

# Detección continua de colisiones {#_detección_continua_de_colisiones}

// TODO: Ojo es con la simulación activada.

Por defecto, las colisiones se detectan de forma discreta, que es la forma más rápida y sencilla de hacerlo. Es decir, que en cada paso en el tiempo de simulación se calcula la posición de los objetos y qué colisiones hay. Sin embargo, esto abre la puerta a que objetos pequeños que se muevan muy rápido puedan pasar a través de otros, en lo que dura un paso en el tiempo de simulación, sin ser detectados. A este fenómeno se lo denomina *tunneling*.

![Problema de la detección de colisión discreta con objetos pequeños que se desplazan rápidamente.](media/discrete_collision_detection.svg)

Algunas posibles soluciones a este problema son:

-   Hacer que el objeto, en cada paso de simulación, lance un *raycast* en la dirección del movimiento para detectar objetos que podría atravesar en el intervalo del tiempo hasta el siguiente paso. En caso de detectar alguno, se lanzan acciones que simula la colisión.

-   Hacer que el objeto tenga una cola invisible, aumentado el tamaño del objeto de forma imperceptible, para que el motor pueda detectar la colisión gracias a la cola.

-   Si el motor lo soporta, activar la detección continua de colisión ---o *continuous collision detection* (CCD)[\[18\]](#NVIDIA-PhysX-CCD), en inglés---.

Tanto Unreal Engine como Unity soportan CCD. En el primero se activa mediante la propiedad **Use CCD** de la sección **Collision** del componente o actor. En el segundo es el componente **RigidBody** el que ofrece varios modos de funcionamiento a través de la propiedad **Collision Detection**. Estos modos son:

-   **Discrete**. Es el modo ya comentado de detección discreta de la colisión (DCD).

-   **Continuous**. Usa detección discreta respecto a otros objetos dinámicos y detección continua respecto a objetos estáticos. El algoritmo que usa se llama *Time Of Impact* (TOI).

-   **Continuous Dynamic**. Igual que el anterior utiliza CCD TOI contra objetos estáticos pero también contra objetos dinámicos configurados con *Continuous* o *Continuous Dynamic*.

-   **Continuous Speculative**. Usa un algoritmo de CCD llamado CCD especulativo, tanto contra otros objetos dinámicos como estáticos. Este es el único modo CCD que se puede usar en objetos cinemáticos y tiende a ser menos costoso que el algoritmo TOI.

## Time of impact (TOI) {#_time_of_impact_toi}

El algoritmo *Time Of Impact* (TOI) ---también llamado CCD basado en barrido--- calcula en cada paso de simulación si hay un posible impacto en la trayectoria del objeto entre la posición actual y la estimada para el siguiente paso. Para esta estimación utiliza la magnitud y dirección de la velocidad lineal actual del objeto. Si detecta una posible colisión, da un sub-paso de simulación hasta ese tiempo y repite el algoritmo, buscando una posible colisión[\[19\]](#Unity-CCD)

Este algoritmo tiene un gran impacto en el rendimiento del motor de físicas. Como no tiene en cuenta la velocidad angular ---sino solo la lineal--- las colisiones debidas a la rotación de los objetos no son detectadas.

## CCD especulativo {#_ccd_especulativo}

Para entender cómo funciona el algoritmo CCD especulativo hay que comprender primero cómo funciona el proceso de detectar colisiones.

Por lo general, se usan dos fases. En la primera se buscan posibles colisiones sustituyendo cada objeto por una figura simple que los envuelve completamente ---un *bounding box*---. Si en el instante de simulación actual estas figuras no se superponen, es que no ha ocurrido ninguna colisión. Mientras que si hay alguna superposición, puede que haya habido alguna colisión entre esos objetos. En la segunda fase se toman estas posibles colisiones y se analiza si en efecto ha habido una colisión, considerando la forma real de la geometría de colisión del objeto[\[20\]](#Souto2015).

En el CCD especulativo, el *bounding box* del objeto usado en la primera fase se expande considerando el movimiento lineal y angular del objeto. De esta forma, no solo cubre el objeto original, sino también todas las posiciones en las que podría estar el objeto a lo largo del siguiente intervalo de simulación. Este nuevo *bounding box* es más grande que el original, por lo que pueda señalar toda una serie de posibles contactos, actuales o futuros. El motor de físicas toma estos posibles contactos como restricciones del movimiento al calcular la siguiente posición del objeto, evitando que atraviese otros objetos[\[19\]](#Unity-CCD).

Esta solución es más eficiente que el algoritmo TOI, pero no es igual de robusta, dado que puede dar lugar a falsas colisiones.

# Materiales físicos {#_materiales_físicos}

Cuando los objetos colisionan, es necesario simular las propiedades físicas de los materiales de su superficie para conseguir efectos más realistas. Por ejemplo, una superficie helada por la que es fácil deslizarse o una de hierba en la que hay más fricción.

Básicamente las propiedades físicas que se pueden simular son dos: **fricción** y el **grado de rebote**. En cualquier caso, hay que tener en cuenta que se trata de una simulación de la dinámica de sólidos rígidos. Aunque se configuren las superficies con un gran grado de rebote ---por ejemplo, para simular una pelota de goma los cuerpos no se van a deformar, como sería de esperar en una simulación realista.

También sirven como forma de identificar el tipo de material con el que se colisiona, para generar efectos de sonido o partículas adecuados.

En Unity se aplican añadiendo el componente **PhysicalMaterial** al mismo *GameObject* que tiene el *collider* que queremos configurar[\[21\]](#Unity-Physics-Material). En Unreal Engine [\[22\]](#UE-Physical-Materials) los **Physical Material** son un tipo de recurso que, una vez creado, se pueden aplicar a materiales, mallas estáticas y **Physics Assets** ---que son quiénes determinan las propiedades físicas de las mallas esqueletales---.

# Colisiones simples frente a complejas {#_colisiones_simples_frente_a_complejas}

En Unreal Engine a los actores se les pueden añadir *colliders*. Sin embargo, hay tipos de recursos donde se permite añadir información sobre las colisiones y comportamiento físico directamente.

Los **Skeletal Mesh** se pueden conectar a otro recurso llamado **Physics Asset**. Este recurso se edita desde el [**Physical Asset Editor**](https://docs.unrealengine.com/en-US/Engine/Physics/PhysicsAssetEditor/index.html) y contiene una definición de los diferentes cuerpos rígidos que conforman las distintas partes de la malla esqueletal y que se usarán durante la simulación física.

::: {.note}
Podemos elegir que el movimiento de la malla esqueletal venga determinado por la animación o por la simulación física, según el caso.
:::

Mientras que los **Static Mesh** son mucho más simples. Unreal Engine soporta importar la geometría de colisión desde el archivo FBX del modelo o añadirla directamente desde el editor **Static Mesh**.

Esta geometría es la geometría de colisión simple. Está formada por formas primitivas, como: cajas, esferas, cápsulas o, en el caso más general, geometrías convexas que se ajusten de forma más precisa a la malla. Sin embargo, al mismo tiempo, Unreal Engine genera automáticamente una geometría de colisión compleja, cuya forma se ajusta perfectamente a la malla del objeto.

::: {.tip}
Se puede indicar a Unreal Engine que no use alguna de las geometrías para el **Static Mesh**, si no la vamos a necesitar. En lo posible, **deberíamos indicar que use la geometría simple como simple y como compleja** para ahorrar recursos.

También se puede indicar que use la geometría compleja como si fuera la simple ---para ahorrarnos crear y guardar la simple--- pero eso es mucho más costoso y presenta importantes limitaciones, tal y como veremos posteriormente
:::

![Configurar qué geometría se usará como compleja o simple en un **Static Mesh**.](media/static_mesh_collision_complexity.jpg)

Esta estrategia nos da la posibilidad de elegir entre consultar la geometría simple o la compleja a la hora de detectar colisiones o hacer *ray casting*.

Por ejemplo, permite que los objetos se muevan por el mundo colisionando según la geometría simple ---que es menos pesada--- pero que al disparar se pueda hacer un *raycast* o lanzar un proyectil contra la geometría compleja, para así conocer el punto exacto del impacto sobre el objeto para lanzar un sistema de partículas, marcarlo con un *decal*[^1] o aplicar un impulso.

Cuando hablamos de **Skeletal Mesh**, generalmente se mueve por el mundo detectando colisiones mediante una cápsula en el componente raíz del actor, que debe envolver a buena parte del personaje. Si se hacen consultas sobre la geometría compleja del componente **Skeletal Mesh**, siempre es contra su **Physics Asset**. Como estos se construyen mediante la unión de formas simples, no es tan precisa como la geometría compleja de un **Static Mesh**.

## Detectar colisiones con geometría compleja {#_detectar_colisiones_con_geometría_compleja}

Detectar colisiones en la geometría compleja es más costoso, por lo que por defecto se usa la simple. Sin embargo, si por cualquier motivos queremos hacerlo así, tenemos diversas opciones:

-   Se puede indicar que un objeto use su geometría compleja como si fuera la simple. Como la geometría simple es la que se usa para detectar las colisiones, esta solución hace que realmente se use la compleja.

-   También es posible activar la propiedad **Trace Complex On Move** en la sección **Collision** de cualquier componente, para que al moverse consulte la geometría compleja de los objetos con los que interactúa, ignorando la simple.

En el primer caso no se puede activar **Simulate Physics**. Esto es debido a que el motor de físicas necesita almacenar la velocidad y otra información en cada vértice de la geometría, siendo esto demasiado costoso para el gran número de vértices de las geometrías complejas. Los objetos que usan la geometría de colisión compleja, desde el punto de vista del motor de físicas, o son cinemáticos o son estáticos.

## Unity {#_unity}

En Unity se puede implementar un sistema similar usando *colliders* y capas:

1.  En el *GameObject* con el componente **MeshRenderer** con la malla se coloca el *mesh collider*, para que así se ajuste a la malla del objeto, mientras que en un *GameObject* hijo se colocaría la cápsula simple del objeto.

2.  El *mesh collider* debe marcarse como *trigger*, para que no sea tenido en cuenta por el motor de físicas y aun así poder detectarlo mediante *ray casting*.

3.  Ambos *colliders* deben ponerse en capas diferentes. Una para las consultas complejas, donde colocar los *mesh colliders*, y otra para las colisiones normales, donde colorar los *colliders* simples.

# Uniones {#_uniones}

Una *unión* conecta un objeto físico con otro o a una ubicación del mundo, aplicando fuerzas a los objetos o restringiendo su movimiento según ciertas reglas. Suelen permitir configurar efectos como su ruptura, cuando se someten a una fuerza que supera cierto umbral, o justar la resistencia de los objetos al movimiento.

::: {.note}
Por ejemplo, una puerta, donde el movimiento de las hojas cuando son empujadas o golpeadas está restringido por las bisagras. Pero podemos hacer que esta *unión* se rompan si el golpe es muy fuerte, desarmando así la puerta.
:::

Como comentamos en el [Colisiones, y cinemáticos](#_colisiones_triggers_y_cinemáticos), los objetos con la simulación física activada no ven restringido su movimiento por su padre, sino que se pueden mover libremente. Las *uniones* permiten construir una jerarquía alternativa en la que restringir el movimiento de los objetos físicos de forma relativa a otros objeto, sean físicos o no.

## Unreal Engine {#_unreal_engine}

En Unreal Engine estas conexiones se denominan *constraints*[\[23\]](#UE-Physics-Constraints) y se pueden crear de dos formas:

-   Usando **Physics Constraint Actor**, que se utiliza para unir dos actores de la escena.

-   O usando **Physics Constraint Component**, que se utiliza para unir dos componentes de un mismo actor.

En ambos casos uno de los componentes o actores debe tener activada la opción **Simulate Physics**.

También se pueden definir *constraints* entre los cuerpos rígidos que definen la física de las **Skeletal Mesh** de los personajes. A estos cuerpos rígidos se los denomina **Physics Bodies** y las uniones se configuran en el [**Physics Asset Editor**](https://docs.unrealengine.com/en-US/Engine/Physics/PhysicsAssetEditor/index.html).

Unreal Engine trae varios tipos de uniones preajustadas que son de uso muy común:

-   **Hinge**. Una unión tipo bisagra. Útil, por ejemplo, para emular puertas.

-   **Prismatic**. Una unión donde solo puede haber deslizamiento en un eje. Útil para emular ascensores, montacargas o plataformas que se deslizan horizontalmente.

-   **Ball and Socket**. Una unión que permite el movimiento al infinito número de ejes que tienen un centro común ---como ocurre con la articulación del hombro--- pero impide cualquier movimiento lineal.

Pero en el fondo las 3 no son más que *constraints* con ciertos valores concretos de configuración. Podemos diseñar nuestras propias uniones con otros parámetros, si nos hace falta.

Además, Unreal Engine ofrece un componente llamado **Physics Handler** que se utiliza para coger un objeto con simulación física y trasladarlo, teniendo en cuenta en todo momento su comportamiento físico. El ejemplo típico es usarlo para implementar algún tipo de pistola física ---como la Gravity Gun de Half Life (1998)--- o poder telequinético con el que coger cosas, trasladarlas con el personaje y luego lanzarlas o depositarlas. El objeto no queda unido al actor que lo «coge», si no este último debe ir actualizando la posición deseada del objeto según dónde desee que esté en cada instante.

## Unity {#_unity_2}

En Unity uno de los dos objetos debe tener el componente **RigidBody**, pues de otra forma el movimiento del objeto no estaría bajo el control del motor de física.

Los tipos de uniones soportadas son:

-   **Character Joint**. Se comporta como el *Ball and Socket*, de forma similar a la articulación del hombro. Se usa especialmente para el efecto *ragdoll* en los personajes.

-   **Fixed Joint**. Limita el movimiento del objeto a seguir el movimiento de otro objeto al que está unido. Es una forma sencilla de conectar el movimiento de dos objetos sin emparentarlos. También sirve para crear uniones fijas que se pueden romper al forzarlas.

-   **Hinge Joint**. Se comporta como una bisagra, permitiendo que un objeto rote alrededor de otro.

-   **Spring Joint**. Permite que un objeto siga a otro a una distancia fija, pero permitiendo que esa distancia se alargue o se acorte si fuera necesario, por las colisiones con otros objetos. Es muy útil para que la cámara siga al personaje, permitiendo crear perspectivas en tercera persona.

Existe otra unión, llamada **Configurable Joint**[\[24\]](#Unity-Configurable-Join), que es muy similar a las *constrains* de Unreal Engine, ya que incorpora toda la funcionalidad de cualquier posible tipo de unión. Solo tenemos que darle los parámetros de configuración adecuados. Obviamente, la lista de parámetros es muy extensa, como ocurre en Unreal Engine.

![Propiedades del componente **ConfigurableJoint**.](media/configurable_joint_props.png)

## Recomendaciones {#_recomendaciones}

Las *uniones* se resuelven en el motor de físicas de forma dinámica. Es decir, no son restricciones reales del movimiento, sino que se implementan mediante mecanismos propios de la teoría del control, aplicando fuerzas variables a los objetos con el fin de contrarrestar ciertos movimientos. Esto puede dar lugar a resultados inestables, si no se tiene cuidado:

-   Es conveniente vigilar la relación entre las masas involucradas, para que en lo posible esta relación sea próxima a 1. Muchos problemas de estabilidad aparecen porque las masas no se han balanceado adecuadamente. Por ejemplo, usando masas pequeñas unidas a otras 1000 veces mayores.

    También hay que tener cuidado con las masas a 0 y tener objetos con escalas negativas, ya que pueden romper la geometría de colisión.

-   Algunas *uniones* pueden ser actuadas mediante un motor o un muelle, que se pueden emplear para simular cierto comportamiento físico. Las simulaciones físicas con *uniones* actuadas son más costosas, pero pueden proporcionar un control más estable de la simulación.

Por ejemplo, supongamos que tenemos una catapulta donde el movimiento del brazo respecto al cuerpo está limitado mediante una *unión*, para que solo pueda rotar desde la posición horizontal a la vertical para lanzar el proyectil. Para el lanzamiento, se pueden intentar ajustar las masas del proyectil y del contrapeso, para que se comporte como una catapulta real, donde el lanzamiento se debe a la diferencia de masa entre ambos. Pero es mucho sencillo y reproducible actuar la unión con un motor que rote la articulación con la velocidad angular que le digamos.

Finalmente, no debemos olvidar que en el mundo real nos gobiernan las leyes de la física, pero en un videojuego podemos obtener mejor resultado sin la simulación de estas leyes. Por ejemplo, hemos comentado que una unión **Prismatic** puede servir para implementar un ascensor y una **Hinge** para una puerta o una catapulta, pero antes de usarlas, debemos pensar qué nos aporta hacerlo utilizando el motor de físicas. ¿Queremos que las puertas se abran de forma «natural» al chocar con ellas?, ¿queremos que se desmonten de formas diversas si las golpeamos muy fuerte, según como sean golpeadas?. Si no nos interesa este tipo de comportamientos, no nos conviene usar las físicas. Lo más frecuente es usar animaciones o trasladar o rotar directamente los objetos; quizás usando curvas para ajustar la velocidad del movimiento forma más realista.

# Ray casting {#_ray_casting_2}

En muchas situaciones es necesario saber si un personaje está viendo algo para iniciar una acción. Por ejemplo, si ve al personaje del jugador para perseguirlo y atacar. O al disparar, saber qué objeto u objetos van a ser alcanzados. Sea como fuere, estas situaciones se resuelven usando *raycasts*, que no son sino la emisión de un rayo invisible que detecta la geometría de colisión por la que pasa.

De hecho, es importante hacer hincapié en eso de detectar geometría de colisión, porque el sistema de *ray casting* consulta la información de los *collider* para encontrar objetos. Por lo tanto, es necesario que aquello que queramos detectar tenga *physical body*, *collisions*, *collider* o lo que sea que represente geometría de colisión en el motor que estemos usando.

## Raycast frente a Overlap {#_raycast_frente_a_overlap}

Aparte de emitir un rayo para detectar los objetos alcanzados, se pueden consultar todos los objetos de una región. Por ejemplo, en Unity los métodos: `OverlapBox()`, `OverlapCapsule()` y `OverlaSphere()` sirven para simular que hubiera en una posición concreta un *collider* con la forma indicada, devolviendo todos los *collliders* dentro de dicha región.

Por el contrario los métodos: `Raycast()`, `BoxCast()`, `` CapsuleCast() y `SphereCast() `` lanzan un rayo desde un punto, con la dirección y forma señalada--- y devuelve el *collider* interceptado[\[25\]](#Unity-Physics).

## Filtrado {#_filtrado}

Todas las funciones de *raycast* permiten filtrar de una manera o de otra los resultados.

En el caso de Unreal, en la categoría *trace channels* ---que se usa para *ray casting*--- hay por defecto dos canales: *visibilty* y *camera*. Si, por ejemplo, un arma tiene una mira láser, la consulta sobre el canal *visibility* nos diría dónde debe pintarse el punto rojo de la mira, puesto que su función es señalar los objetos visibles para el personaje[\[26\]](#UE-Traces).

![Configuración de un nuevo canal personalizado.](media/col_custom_presets.jpg)

Sin embargo, podemos crear un canal personalizado llamando *weapon* y marcar en el como *block* los objetos que pueden ser impactados por un arma. La consulta a este canal nos dirá el punto donde impactará el proyectil. Este no tiene que ser el mismo objeto que el de *visibility*, si hay objetos visibles que el proyectil en cuestión pueda atravesar fácilmente, impactando en otro situado detrás.

![Ejemplo del uso de los *trace channels* --- Fuente: [Epic Games](https://www.unrealengine.com/en-US/blog/collision-filtering).](media/trace_example.jpg)

En Unity el filtrado se hace de forma muy similar. Los objetos pueden estar en alguna de 32 las capas posibles y en las funciones de *raycast* se puede indicar cuáles de esas capas queremos consultar.

### Obtener uno o múltiples objetos {#_obtener_uno_o_múltiples_objetos}

Ya hemos comentado que en los *Overlap* se pueden obtener todos los objetos de una región. Con los *raycast* se traza un rayo entre dos puntos y se puede elegir recuperar el primer objeto encontrado o todos los atravesados durante el recorrido.

Obviamente, en ambos casos se pueden aplicar los criterios de filtrado que comentamos en el apartado anterior.

### Raycasts con forma {#_raycasts_con_forma}

Cuando queremos detectar si un personaje ve a un enemigo, no es suficiente lanzar un rayo, puesto que solo examina una línea en el espacio, mientras que para simular la visión del personaje necesitamos barrer una región más amplia.

En ese caso se puede lanzar un *raycast* con una forma determinada, que se desplace a lo largo del recorrido del rayo, detectado los objetos interceptados. Por ejemplo, Unity proporciona las funciones: `Raycast()`, `BoxCast()`, `CapsuleCast()` y `SphereCast()`, La primera se utiliza para emitir un rayo puntual, mientras que las siguientes barren el espacio con un cubo, una cápsula y una esfera, respectivamente.

### Usarlos de forma inteligente {#_usarlos_de_forma_inteligente}

Los *raycast* son una consulta a la geometría de colisión. No son caros, por lo que no pasa nada si en un fotograma tenemos que hacer muchos, pero tampoco son gratis. Por eso, siempre que podamos, deberíamos valorar alternativas menos costosas.

Por ejemplo, supongamos el caso de un personaje que tiene que detectar si el jugador está cerca. Lo más directo sería lanzar un *raycast* con forma de esfera y ver si detecta algo pero:

1.  Es evidente que el personaje no podrá ver al jugador si está a varios kilómetros, aunque no haya ningún obstáculo entre uno y otro. Por eso una primera comprobación podría ser si el jugador está al menos a cierta distancia.

2.  Incluso si el jugador está cerca, el personaje difícilmente lo verá si está de espalda, ya que tiene un campo de visión limitado. Por lo tanto, la segunda comprobación podría ser calcular si el jugador está dentro del campo de visión. Esto es sencillo, conociendo la posición del personaje y del jugador.

3.  Finalmente, si todas las comprobaciones anteriores son positivas, se podría hacer el *raycast* para asegurar que el personaje ve al jugador. Porque aunque esté dentro del campo de visión y a una distancia razonable, el jugador podría estar escondido detrás de otro objeto. Así que necesitamos confirmar si es visible o no.

::: {.tip}
Todas las funciones de *raycast* y *overlap* de Unity tienen una versión *NonAlloc* donde el que invoca la función es el responsable de reservar el buffer donde almacenar los resultados, en lugar de dejar que lo haga la función de *raycast* llamada.

El objetivo es evitar reservas de memoria que después pueden generar basura que acabe activado el recolector de basura. Por eso es totalmente recomendable usar estas versiones antes que las que no son *NonAlloc*.
:::

# Balas y proyectiles {#_balas_y_proyectiles}

Para implementar balas y otro tipo de proyectiles en juegos de acción, básicamente podemos usar *raycasts*, proyectiles balísticos o combinar de ambas opciones.

## Ray castings {#_ray_castings}

El uso de *raycasts* es, con diferencia, la opción más sencilla. Al disparar, se lanza un rayo para descubrir si algún objeto es alcanzado en la trayectoria Si es así, se le aplica dañó.

El *raycast* puede limitarse a una distancia máxima, si el arma tiene un alcance limitado. También se pueden detectar múltiples objetos en la trayectoria, simulando que el arma tiene una gran capacidad de penetración. O se pueden marcar ciertas superficies como reflectivas, de forma que si impacta en una de ellas hagamos un nuevo *raycast* en la dirección de reflexión, simulando que los disparos pueden rebotar.

La ventaja es que los *raycasts* son una operación muy eficiente, que no necesita simulación física. Además es muy sencilla de utilizar en juegos multijugador en red, porque el *raycasts* se hace en el servidor, mientras solo hay que comunicar a los clientes el daño infligido y los efectos visuales.

Como contrapartida, el impacto es instantáneo, por lo que no hay manera de esquivar las balas. Tampoco resulta realista en disparos a muy larga distancia, donde la gravedad, el viento y otros factores ambientales deberían tener efecto en la trayectoria del proyectil. Por tanto, el uso de *raycasts* no es la mejor opción si interesa crear una experiencia realista.

## Proyectiles balísticos {#_proyectiles_balísticos}

La forma de conseguir una experiencia más realista e inmersiva es lanzar proyectiles. Es decir, crear objetos, impulsarlos en la dirección del disparo y simular su movimiento según su masa, velocidad, gravedad, dirección del viento o cualquier otra fuerza que pueda alterar la dirección del proyectil.

Esta solución permite que los proyectiles se puedan esquivar ---al menos en disparos a grandes distancias o cuando se introducen efectos como el *bullet-time*, donde el tiempo se ralentiza temporalmente---. También obliga al jugador a prever el movimiento de los enemigos y del proyectil, para disparar allí donde cree que estará cuando el proyectil llegue. Y permite añadir tipos diferente de armas que difícilmente se pueden implementar mediante *raycasts*, como granadas y lanzacohetes.

Como contrapartidas:

-   El uso de proyectiles es bastante más costoso que los *raycasts*, porque crear decenas de objetos no resulta barato. En este sentido, es necesario considerar el uso de *pools* de objetos para reusar los objetos creados, reduciendo el coste de crearlos en el momento.

-   Los cálculos del movimiento también tiene su coste y presentar varios retos:

    -   Uno de ellos es hacer los cálculos con la suficiente frecuencia, porque si el proyectil se mueve muy rápido ---cubriendo grandes distancia entre intervalos de tiempo--- se puede dar el caso de que no se detecten algunas colisiones. Por eso es común que los cálculos se hagan con mayor frecuencia y de forma independiente a la tasa de refresco del *render*.

    -   En cada paso de simulación la trayectoria suele aproximarse mediante segmentos rectilíneos, por lo que se puede usar cierto número de subpasos en cada paso, con el objeto de calcular una trayectoria más realista.

    -   Con el objeto de evitar fallar en la detección de posibles obstáculos, puede ser necesario considerar algunas de las técnicas comentadas en el [Detección continua de colisiones](#_detección_continua_de_colisiones), como añadir a los proyectiles una cola invisible o hacer un *raycast* o traslación con *barrido* con la forma del proyectil en cada paso de simulación.

-   El uso de proyectiles suponen un reto adicional en los juegos multijugador en red, porque implica tener decenas de objetos cuyo movimiento debe sincronizarse entre todos los clientes, para evitar crear inconsistencias en la experiencia de los distintos jugadores. Por lo general, cada cliente ejecuta su propia simulación de los proyectiles, que se va corrigiendo periódicamente con la información que llega del servidor, que ejecuta su propia simulación y que es la única fuente de información confiable.

## Sistemas híbridos {#_sistemas_híbridos}

En muchos videojuegos se utilizan ambos tipos de soluciones. Esto da la opción de tener una gran cantidad de armas con diferentes caracteristicas, de forma que en cada una se usa la solución que ofrece los mejores resultados.

# Controlador de personaje {#_controlador_de_personaje}

El controlador de personaje es el componente que se encarga del control del movimiento de los personajes. La entrada del controlador es el movimiento deseado ---por ejemplo, «muévete hacia adelante a 3 m/s» o «salta»--- y la salida es la nueva posición del personaje ajustada a las restricciones del mundo.

El controlador de personaje suele tener características específicas del juego. Por ejemplo, la forma del personaje se modela con un volumen sencillo que se usa para detectar sus colisiones con el entorno. Frecuentemente, este volumen es una cápsula, pero también puede ser una esfera o una caja, según se ajuste mejor a la figura del personaje y al movimiento. Además, los tipos de movimiento y las formas de moverse depende mucho del juego. En algunos juegos se puede saltar, nadar, trepar o correr; mientras que en otros no.

Por lo tanto, es responsabilidad del controlador del personaje evitar que el personaje atraviese muros y suelos, que pueda subir y bajar pendientes y escaleras o que al movimiento se le apliquen los efectos de la gravedad.

![Actor Character de Unreal Engine.](media/ue_empty_character.png)

## Tipos de controladores {#_tipos_de_controladores}

Los controladores de personaje pueden ser **dinámicos** o **cinemáticos**.

### Controladores dinámicos {#_controladores_dinámicos}

Los **controladores de personaje dinámicos** utilizan el motor de físicas, por lo que en teoría son muy sencillos de implementar.

Pueden usar como entrada la velocidad ---control de segundo orden--- pero lo más frecuente es emplear la aceleración ---control de tercer orden--- deseada para el personaje, puesto que modificar directamente la velocidad puede dar lugar a comportamientos no realistas.

Solo necesitamos activar la simulación física en el personaje ---por ejemplo, añadiendo un componente **RigidBody** en Unity--- y en cada actualización aplicar una fuerza, calculada a partir de la aceleración indicada como entrada del controlador. El motor de físicas se hará cargo de calcular la posición futura del personaje automáticamente. Sin embargo, el movimiento no suele ser tan suave y controlable como con un controlador **cinemático**.

Algunos problemas típicos de los controladores **dinámicos** son:

-   **Carecen de control directo del desplazamiento**. Los objetos con simulación física generalmente se controlan mediante impulsos y fuerzas. No se los mueve directamente a la posición final deseada, sino que se tienen que calcular las fuerzas a aplicar, a partir del desplazamiento deseado para el personaje, y aplicarlas, con la esperanza de que la simulación física lleve al objeto hasta dicha posición deseada. Obviamente, no resulta sencillo y no siempre funciona como esperamos.

-   **Problemas con la fricción**. Un personaje no debe deslizarse hacia abajo cuando está de pie sobre una rampa, lo indica que esperamos que la fricción sea muy alta. Pero cuando sube por ella, esperamos que la fricción sea 0, de forma que no se mueva más despacio que por otras superficies del juego. Tampoco esperamos que el personaje se mueva más despacio cuando se desliza contra un muro. Este tipo de comportamiento poco realista es muy complicado de controlar ajustando los parámetros del motor de físicas.

-   **Problemas con las restituciones**. Cuando dos objetos chocan, uno puede superponerse temporalmente al otro. Se denomina restitución al proceso por el cuál se resuelve la colisión para deshacer esa superposición.

    En problema es que las restricciones del motor de física pueden mostrar cierto efecto rebote, porque se resuelven aplicando fuerzas lo suficientemente intensas como para separar lo más rápido posible los objetos superpuestos. Si las fuerzas son excesivas, los objetos pueden separarse demasiado, como si hubieran rebotado. Pero cuando un personaje que se mueve muy rápido colisiona contra una superficie ---quizás porque está corriendo o porque está cayendo desde cierta altura--- no queremos que rebote.

-   **Saltos no deseados**. Si un personaje corre por una rampa a gran velocidad, el motor de físicas generalmente lo hace saltar cuando llega al final de la rampa, debido a la inercia del movimiento, que le hace mantener la dirección temporalmente. Sin embargo, no se suele desear ese efecto ---a menos que estemos desarrollando un simulador de conducción--- sino que esperamos que el personaje permanezca pegado al suelo en todo momento.

-   **Rotaciones no desadas**. Los personajes suelen permanecer de pie, por lo que no solemos querer que la cápsula que los rodea rote. Debe estar siempre en vertical, apoyada sobre uno de sus extremos en el suelo. Lamentablemente, los motores de físicas suelen carecer de las características necesarias para restringir este tipo de rotaciones.

Algunas de estos problemas se pueden resolver usando *uniones*, que a veces no funcionan del todo bien porque son dinámicas. Es decir, se basan en aplicar fuerzas para intentar restringir ciertos movimientos. Otras opciones son que el controlador aplique por sí mismo ciertas fuerzas en momentos concretos o ajustar de forma cuidados algunos parámetros del motor de físicas.

Todo para emular con un motor de físicas un comportamiento mucho más simple de aquel para el que el motor fue diseñado. Por eso, suele ser mucho más sencillo y estable implementar directamente el comportamiento deseado en un controlador cinemático, dejando de lado el motor de físicas.

### Controladores cinemáticos {#_controladores_cinemáticos}

Los **controladores de personaje cinemáticos** calculan la posición final del personaje a partir de la entrada del controlador. Entonces el personaje es movido hasta allí, se detectan las colisiones, se busca la posición viable ---sin superposiciones--- más cercana a la posición deseada y, finalmente, el personaje es movido hasta ese punto. A este algoritmo se lo denomina ***collide and slide***.

El controlador suele soportar distintos métodos para hacer el *slide* y mover el personaje hasta una ubicación viable, según las mecánicas del juego: Por ejemplo: volar, caminar o correr, subir o bajar escalones o rampas, saltar y maniobrar en el aire, moverse sobre plataformas ---como ascensores o cintas transportadoras--- empujar objetos, nadar o escalar. Estos métodos se utilizan según el estado en el que está personaje ---si está «saltando», porque el jugador ha pedido que salte, o está «nadando» porque ha entrado en un volumen marcado como de agua--- o según las colisiones detectadas ---si estamos sobre el suelo se puede caminar, pero no maniobrar en el aire o si se detecta un obstáculo se puede intentar superar como un escalón---. Cuando el controlador es complejo, el uso de máquinas de estados es una muy buena opción para su implementación.

La entrada del controlador puede ser directamente el desplazamiento deseado ---control de primer orden--- pero también puede ser la velocidad o la aceleración deseada para el personaje. En todos los casos se calcula la posición final usando las ecuaciones cinemáticas, para luego aplicar el algoritmo ***collide and slide*** comentado.

En el pasado, los videojuegos no tenían un motor de físicas. En único componente que tenía algo de física era el **controlador de personaje**, que funcionaba tal y como hemos descrito, de forma **cinemática** Hoy en día se sigue utilizando porque ofrece un control más directo y estable que los **controladores dinámicos** basado en el motor de físicas.

## Unity {#_unity_3}

En Unity el **CharacterController** es un controlador **cinemático** bastante simple, por lo que muchas veces acaba teniendo que ser sustituido por una implementación propia o comprada en la *Asset Store*.

Básicamente permite mover el personaje sobre una superficie, con pendientes y escalones. Otras acciones básicas, como pueden ser salto, maniobrar en el aire o agacharse, debemos implementarlas por nuestra cuenta, aunque no resulta complicado con la información proporcionada por el controlador.

## Unreal Engine {#_unreal_engine_2}

En Unreal Engine el **Character** incluye el componente **CharacterMovementComponent**, que se encarga del control del movimiento del personaje y también se implementa de forma **cinemática**.

**CharacterMovementComponent** ofrece todo el soporte necesario para un *shooter* en primera o tercera persona, con modos para caminar, saltar, agacharse, volar o nadar, pudiendo ajustar distintos parámetros en cada modo ---como la velocidad máxima del movimiento o las pendientes máximas y escalones---. Para añadir otros modos ---como escalar o subir escaleras de mano--- solo es necesario heredar de la clase y seguir los pasos para implementar un *modo de movimiento personalizado*.

**CharacterMovementComponent** y el actor **Character** están bien integrados, por lo que también se encarga de hacer ajustes al resto de componentes del **Character**, según el modo de movimiento. Por ejemplo, el controlador sabe ajustar el tamaño de la cápsula cuando el personaje se agacha.

Igualmente, se integra con el sistema de navegación, permitiendo que el **AIController** de un NPC marque un destino y el sistema de navegación considere para llegar a él los modos de movimiento soportados por el **CharacterMovementComponent**. Con la ruta obtenida, el **AIController** mueve el personaje dando órdenes de desplazamiento al **CharacterMovementComponent**, para llegar a los distintos puntos de dicha ruta usando los modos de movimiento adecuados.

# Tejidos {#_tejidos}

El soporte para simular tejidos se basa en lo que puede hacer NVIDIA Cloth, tanto en Unreal Engine 4 como en Unity. Eso significa que el flujo de trabajo y las limitaciones son muy similares. En Unreal Engine 5 el nuevo motor de físicas Chaos Physics incluye su propia solución para simular tejidos.

La simulación de tejidos solo funciona con mallas esqueletales, como las que se usan con los personajes para poder animarlos. De hecho, la herramienta está especialmente diseñada para personajes.

## Activar el soporte de este tipo de simulación. {#_activar_el_soporte_de_este_tipo_de_simulación}

En Unity se añade el componente **Cloth** al objeto con el **SkinnedMeshRenderer** con la porción de malla que se quiere simular como tejido ---por ejemplo, una capa--- y se configura según las características del tejido a simular. Diferentes tejidos deberán estar en diferentes *GameObjects* con sus componentes **Cloth** y su **SkinnedMeshRenderer**[\[27\]](#Unity-Cloth).

En Unreal Engine se selecciona la parte de la malla que interesa en el editor de **Skeletal Mesh**, se elige crear un **Clothing Asset** a partir de la selección y se configuran en el *asset* las características del tejido. Unreal Engine permite seleccionar diferentes partes de la malla y crear un *asset* de este tipo para cada una[\[28\]](#UE-Cloth).

## Activar la detección de colisión. {#_activar_la_detección_de_colisión}

El tejido debe reaccionar ante las interacciónes con otros cuerpos físicos, pero no lo puede hacer con cualquier cuerpo de la escena, porque eso generaría problemas de rendimiento. Es necesario decirle de qué otros cuerpos debe estar atento.

En Unreal Engine se le indica al **Clothing Asset** el **Physical Asset** del personaje que lleva la prenda. El **Physical Asset** tiene los cuerpos rígidos que describen la física del personaje.

En Unity hay que configurar en el componente **Cloth** los *colliders* del personaje con los que se quiere simular la colisión. Por ejemplo, los *colliders* de las extremidades.

::: {.note}
Hay que tener en cuenta que es la ropa la que se va a desplazar por culpa de esos otros objetos. Nunca ocurrirá al revés.
:::

## Asignar nivel de influencia de la simulación {#_asignar_nivel_de_influencia_de_la_simulación}

Finalmente, queda editar el nivel de influencia de la simulación en cada vértice de la malla. Ambos motores permiten usar un pincel con el que se pintan esos «valores» de influencia.

# Ragdolls {#_ragdolls}

Los *ragdolls* son una técnica utilizada para animar el movimiento de los personajes cuando mueren. En realidad lo que se hace es desactivar la animación esqueletal y ceder el control del movimiento del cuerpo al motor de físicas.

Para que el motor de físicas sepa qué hacer con él, previamente se deben haber configurado las distintas partes del cuerpo como cuerpos rígidos y las uniones entre ellos con las restricciones de movimiento adecuadas.

## Unreal Engine {#_unreal_engine_3}

En Unreal Engine estos *Physical Bodies* y las *constraints* de las articulaciones se configuran en el [Physics Asset Editor](https://docs.unrealengine.com/en-US/Engine/Physics/PhysicsAssetEditor/index.html).

A la hora de activar el *ragdoll* es necesario:

1.  Activar la simulación de la física en todos los huesos del personaje. Para eso en *blueprint* se llama a **Set All Bodies Below Simulate Physics** indicado el hueso de la cadera ---o el que corresponda--- como el primero de la jerarquía. En C++ se usa el método `SetAllBodiesBelowSimulatePhysics()` del componente `USkeletalMeshComponent`.

2.  Indicar que el peso de la simulación física en la animación es 1.0. Para eso en *blueprint* se usa **Set All Bodies Below Physics Blend Weight**. En C++ se usa el método `SetAllBodiesBelowPhysics Blend Weight()` del componente `USkeletalMeshComponent`.

::: {.tip}
Si queremos, este último parámetro nos permite crear un efecto más cinematográfico, al poder cambiar el peso con el tiempo, siguiendo una curva. Esto permite que primero tenga más peso la animación que se estaba reproduciendo ---por lo que seguiría haciendo lo que estaba haciendo--- pero que tras unos instantes vaya dominando el movimiento la simulación física, con lo que el cuerpo va cayendo como un peso muerto.
:::

Al poder controlar a partir de qué hueso de la jerarquía se aplica el efecto, podemos darle otros usos. Por ejemplo, que le personaje cuelgue de una cornisa, de forma que la parte superior del cuerpo esté animado, mientras la parte inferior cuelga libremente por su propio peso.

## Unity {#_unity_4}

Igualmente, en Unity hay que añadir los componentes **RigidBody** y **CharacterJoint** en las distintas partes del cuerpo. Esto se puede hacer a mano o utilizando el [Ragdoll Wizard](https://docs.unity3d.com/Manual/wizard-RagdollWizard.html).

Lo más común, es marcar todos esos **RigidBody** como cinemáticos. Así el personaje será animado con normalidad. Cuando se quiera activar el *ragdoll*, solo hay que buscar los **RigidBody** y desactivar el modo cinemático para que el motor de físicas tome el control

Obviamente, esta técnica no permite controlar la mezcla entre la animación esqueletal y la simulación física, como si se puede hacer en Unreal Engine. Lamentablemente, Unity no trae nada de serie para hacerlo.

Si nos interesase, sería necesario utilizar algún recurso del *Asset Store* ---como el famoso [PuppetMaster](https://assetstore.unity.com/packages/tools/physics/puppetmaster-48977)--- o implementarlo por nuestra cuenta. En este sentido, una posible solución sería:

1.  Tener en el personaje la malla dos veces. Dos jerarquías de *GameObjects* unidas en una raíz común, para que se desplacen juntas. Una es la jerarquía que tiene el esqueleto que responde a la animación. Mientras la otra tiene los **RigidBody** conectados mediante **Joints**, que se moverán según la simulación física.

2.  En condiciones normales, mientras el personaje está vivo, el *script* mantiene ocultos los *GameObjects* de la segunda jerarquía, que tendrá todos los **RigidBody** en modo cinemático.

3.  En el momento de la muerte: el *script* copia las posiciones de los *GameObjects* de la primera jerarquía en la segunda, ocultar la primera, muestra la segunda y desactivar el modo cinemático de los **RigidBody** de la segunda jerarquía.

4.  En cada *frame* de tiempo se desplazan los *GameObjects* de la segunda jerarquía ---ahora visibles--- a una posición interpolada entre lo predicho por la simulación física y la animación del personaje en la primera jerarquía de objetos ---ahora oculta---. El punto interpolado depende del peso de la simulación respecto a la animación, que puede cambiar dinámicamente a lo largo del tiempo usando una curva.

# Destruibles {#_destruibles}

NVIDIA ha venido desarrollando diversas herramientas a lo largo del tiempo para simular destrucciones con PhysX. Hasta hace poco era una funcionalidad incluida dentro de NVIDIA APEX PhysX ---al igual que el antiguo sistema de simulación de tejido--- pero actualmente es un producto discontinuado y se recomienda migrar a [NVIDIA Blast](https://developer.nvidia.com/blast).

## Unreal Engine {#_unreal_engine_4}

Unreal Engine 4 soporta tanto APEX Destruction como Blast, ambos a través de *plugins* con el mismo nombre[\[30\]](#UE-APEX-Plugin)[\[31\]](#UE-Blast-Plugin). Sin embargo, Epic Games ha marcado el soporte de APEX como obsoleto, por lo que es de esperar que lo retiren en un futuro.

Además, desde Unreal Engine 4.23 se incluye en *preview* Chaos Physics, que tiene su propio sistema de destrucción, siendo la solución por defecto en Unreal Engine 5.

### APEX {#_apex}

Las mallas destruibles se denominan **APEX Destructible Assets** y se pueden generar desde una herramienta externa ---llamada NVIDIA APEX PhysX Lab--- y luego importarlas o desde el editor de **Destructible Assets** de Unreal Engine. En este último caso, el editor hace la división de forma automática, usando la Teselación de Voronoi[\[29\]](#Wikipedia-Polígonos-Thiessen) y limitada un solo nivel de destrucción.

Para crear un **Destructible Asset** desde el editor de Unreal Engine se debe seleccionar **Create Destructible Mesh** en el menú contextual del editor, con la malla estática que se quiere hacer destruible seleccionada. El editor de **Destructible Assets** también permite ajustar parámetros de la configuración de la destrucción, como: la fuerza necesaria o si se generarán escombros; a través de las opciones en **Destructible Settings**[\[32\]](#UE-Destructible-Properties).

Para que el actor se destruya en caso de colisión, debemos recordar que las opciones **Simulate Physics** y **Simulation Generates Hit Events** del actor deben estar activados. También podemos hacerlo desde el código del juego, usando los métodos para aplicar fuerzas, impulsos y daño, sobrescritos por el componente **DestructibleComponent**[\[33\]](#UE-Destructible-Component).

En caso de problemas es conveniente consultar la guía de problemas en el Wiki de Unreal Engine[\[34\]](#UE-Wiki-Destructible-Troubleshooting-Guide).

### Blast {#_blast}

El flujo de trabajo con Blast es muy similar al de APEX. Lo primero es crear un **Blast Asset** seleccionando **Create Blast Mesh** en el menú contextual del **Static Mesh** que se quiere que sea destruible. Con esta acción se abre el **Blast UE4 Mesh Editor**, que permite fracturar el objeto y ajustar distintos parámetros de configuración[\[31\]](#UE-Blast-Plugin).

Luego el recurso puede ser arrastrado a la escena para crear un actor Blast. En la sección **Blast** de las propiedades del actor se pueden ajustar los parámetros del objeto destruible.

Los actores Blast se pueden destruir mediante colisión ---por un impacto o porque se le aplica un impulso directamente--- usando la API **Damage** del actor o mediante estrés ---al aplicar fuerzas en distintos puntos del objeto que hacen que este se fracture---.

## Unity {#_unity_5}

Unity actualmente no incluye de serie ninguna herramienta para crear destruibles. En el repositorio de Blast hay un proyecto de ejemplo de cómo se puede integrar con Unity[\[35\]](#NVIDIA-Blast-GitHub). Si bien este ejemplo es para Unity 2018.2, se puede usar como referencia para tratar de integrarlo en versiones más actuales.

En todo caso, también podemos desarrollar una solución propia. Si creamos en un modelador 3D una versión fracturada del modelo, se puede sustituir el modelo no fracturado por el fracturado ---con *colliders* y **RigidBody** en cada pieza--- en el momento del impacto.

Incluso se puede evitar la sustitución del *GameObject* jugando con tener los *colliders* desactivados y el **RigidBody** en modo cinemático. Es decir:

1.  En el *GameObject* raíz se coloca un componente **RigidBody** y un *collider* global que cubre todo el objeto.

2.  En cada pieza de la ruptura se coloca un **RigidBody** en modo cinemático y un *collider* desactivado. Por lo general, será un *mesh collider* convexo, para que se ajuste bien a la pieza, sin consumir demasiados recursos.

3.  Se añade y configura un sistema de partículas en el **GameObject** raíz, para simular polvo o pequeños trozos que se desprenden en el impacto.

Para dar más realismo, se puede distinguir entre impactos realmente fuertes, que destruyen completamente el objeto, de aquellos que solo lo fracturan en parte.

Los impactos detectados por encima de un umbral configurable, pueden provocar la destrucción completa del objeto:

1.  Haciendo cinemático el **RigidBody** raíz.

2.  Desactivando el *collider* raíz.

3.  Activando los *colliders* de cada pieza.

4.  Desactivando el modo cinemático de los **RigidBody** de cada pieza.

Mientras que por debajo de dicho umbral, solo provocaría su destrucción parcial: activando los *colliders* y desactivando el modo cinemático de los **RigidBody** de las piezas que van a ser impactadas según la dirección y velocidad del proyectil, en lugar de hacerlo para todas las piezas del objeto.

También se puede aplicar cierta fuerza en dirección radial sobre las piezas en el punto de impacto para simular una explosión.

# Referencias {#_referencias}

# 

\[1\] Método de Gauss-Seidel. En *Wikipedia*. <https://es.wikipedia.org/wiki/M%C3%A9todo_de_Gauss-Seidel>

\[2\] Método de los elementos finitos. En *Wikipedia*. <https://es.wikipedia.org/wiki/M%C3%A9todo_de_los_elementos_finitos>

\[3\] *Open Dynamics Engine*. <http://www.ode.org>

\[4\] *Bullet Real-Time Physics Simulation*. <https://pybullet.org/>

\[5\] NVIDIA. *PhysX*. <https://developer.nvidia.com/physx-sdk>

\[6\] Epic Games, Inc. Physics. *Unreal Engine 5 Documentation*. <https://docs.unrealengine.com/5.0/en-US/physics-in-unreal-engine/>

\[7\] *Havok*. <http://www.havok.com>

\[8\] <https://blogs.unity3d.com/es/2019/11/06/havok-physics-in-unity/>

\[9\] <https://assetstore.unity.com/subscriptions/havok>

\[10\] Pixelux Entertainment. *Digital Molecular Matter*. <https://www.pixelux.com/DMMengine.html>

\[11\] Joachim\_Ante. (2019, 19 de marzo). *The goal of Unity.Physics* \[Comentario en la discusión *Unity Physics Discussion*\]. Unity Forums. <https://forum.unity.com/threads/unity-physics-discussion.646486/#post-4336525>

\[12\] Convex set. En *Wikipedia*. <https://en.wikipedia.org/wiki/Convex_set>

\[13\] NVIDIA. Vehicles. *NVIDIA PhysX SDK 3.4.0 User's Guide*. <https://docs.nvidia.com/gameworks/content/gameworkslibrary/physx/guide/Manual/Vehicles.html>

\[14\] Unity Technologies. Wheel Collider Tutorial. *Unity Manual*. <https://docs.unity3d.com/Manual/WheelColliderTutorial.html>

\[15\] Epic Games, Inc. Simple Wheeled Vehicle Movement Component. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/4.27/en-US/InteractiveExperiences/Vehicles/SimpleWheeledVehicleMovementComponent/index.html>

\[16\] Epic Games, Inc. Vehicle User Guide. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/4.27/en-US/InteractiveExperiences/Vehicles/VehicleUserGuide/index.html>

\[17\] Unity Technologies. Colliders. *Unity Manual*. <https://docs.unity3d.com/Manual/CollidersOverview.html>

\[18\] NVIDIA. Continuous Collision Detection. *NVIDIA PhysX SDK 3.4.0 User's Guide*. <https://docs.nvidia.com/gameworks/content/gameworkslibrary/physx/guide/Manual/AdvancedCollisionDetection.html#continuous-collision-detection>

\[19\] Unity Technologies. Continuous Collision Detection. *Unity Manual*. <https://docs.unity3d.com/Manual/ContinuousCollisionDetection.html>

\[20\] Souto, N. (2015). *Video Game Physics Tutorial - Part II: Collision Detection for Solid Objects*. <https://www.toptal.com/game/video-game-physics-part-ii-collision-detection-for-solid-objects>

\[21\] Unity Technologies. Physic Material. *Unity Manual*. <https://docs.unity3d.com/Manual/class-PhysicMaterial.html>

\[22\] Epic Games, Inc. Physical Materials. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/en-US/Engine/Physics/PhysicalMaterials/index.html>

\[23\] Epic Games, Inc. Physics Constraints. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/en-US/Engine/Physics/Constraints/index.html>

\[24\] Unity Technologies. Configurable Joint. *Unity Manual*. <https://docs.unity3d.com/Manual/class-ConfigurableJoint.html>

\[25\] Unity Technologies. Physics. *Unity Manual*. <https://docs.unity3d.com/ScriptReference/Physics.html>

\[26\] Epic Games, Inc. Traces with Raycasts. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/en-US/InteractiveExperiences/Tracing/index.html>

\[27\] Unity Technologies. Cloth. *Unity Manual*. <https://docs.unity3d.com/Manual/class-Cloth.html>

\[28\] Epic Games, Inc. Clothing Tool. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/en-US/InteractiveExperiences/Physics/Cloth/Overview/index.html>

\[29\] Polígonos de Thiessen. En *Wikipedia*. <https://es.wikipedia.org/wiki/Pol%C3%ADgonos_de_Thiessen>

\[30\] Epic Games, Inc. APEX. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/4.27/en-US/Engine/Physics/Apex/index.html>

\[31\] NVIDIA. *Blast UE4 Plug In Guide*. <https://docs.nvidia.com/gameworks/content/gameworkslibrary/blast/1.1/authoring_docs/BlastUe4_viewerReference.html>

\[32\] Epic Games, Inc. Destructible Properties Matrix. *Unreal Engine 4 Documentation*. Archivado en <https://web.archive.org/web/20170708165110/https://docs.unrealengine.com/latest/INT/Engine/Physics/Destructibles/DestructibleProperties/index.html>

\[33\] Epic Games, Inc. Destructible Component. *Unreal Engine 4 Documentation*. <https://docs.unrealengine.com/en-US/BlueprintAPI/Components/Destructible/index.html>

\[34\] Destructible Troubleshooting Guide. En *Old UE4 Wiki*. <https://nerivec.github.io/old-ue4-wiki/pages/destructible-troubleshooting-guide.html>

\[35\] NVIDIA. Blast \[Repositorio de software\]. <https://github.com/NVIDIAGameWorks/Blast>

[^1]: Un *decal* es una textura que se pone sobre otra para, por ejemplo, marcar zonas de impacto, crear manchas o pisadas y otros efectos similares.
