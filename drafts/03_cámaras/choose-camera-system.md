![La cara de una persona Descripción generada automáticamente con
confianza baja](media/image1.jpeg){width="5.905555555555556in"
height="3.3222222222222224in"}

**22 SEP DESIGN: CHOOSING A CAMERA SYSTEM**

Posted at
13:52h in [[Design]{.underline}](https://web.archive.org/web/20201028145018/https:/www.hellblade.com/category/design/), [[R21]{.underline}](https://web.archive.org/web/20201028145018/https:/www.hellblade.com/category/r21/) by [[Dom]{.underline}](https://web.archive.org/web/20201028145018/https:/www.hellblade.com/author/domvsalex/) [[16
Comments]{.underline}](https://web.archive.org/web/20201028145018/https:/www.hellblade.com/choosing-a-camera-system/#comments) 

[[11Likes]{.underline}](https://web.archive.org/web/20201028145018/http:/www.hellblade.com/choosing-a-camera-system/)

 

[Share](javascript:void(0))

-   
-   
-   
-   
-   
-   
-   

**Tameem Antoniades**

Hello, I am currently preparing for my first ever appearance at DICE
Europe. It's basically a conference for grown-up big-wigs in the games
industry so I'm quite nervous about doing it. They originally invited
Nina Kristensen, our Chief Development Ninja and co-founder, but she put
me forward for it, despite my pleadings and protestations.

Anyway, despite that, I wanted to put something out there for you as
Monday's are becoming a regular thing in terms of releasing some info. 
Melina is away on holiday so we don't have a juicy video for you this
time. Instead, I've put together a little design blog about choosing a
camera system for Hellblade.  I think it's worth reading if you are
interested in nuts and bolts game design.  Otherwise, I'm afraid you may
find it rather dry.

Choosing a camera view is one of the first and most important decisions
to be made on a game.  It's right up there with controls and character
actions.  Is the game going to be 2D, isometric, first person or
3^rd^ person?  Any system chosen will have massive ramifications on how
you build the game, how you control it and how it will feel.  It may
seem like the dog wagging the tail, but I feel it is smarter to design
the game around your camera choice and not the other way around.

When I was working at Sony Europe about 15 years ago I had to design a
3^rd^ person camera system for a game I was working on.  I analysed over
40 games, documented what worked and what didn't.  It is much cheaper to
learn from other games, both good and bad than to endlessly prototype
what you think is right.

People may reasonably suppose that one of the most important skills of a
designer is coming up with good ideas.  Personally I would put that way
down the list of important skills.  Ideas are cheap, everyone has them,
but few can articulate them, break them down, implement them and make
them feel good.  So one skill I would put very near the top is
"analysis".

I reverse engineered and tested every camera attribute from the angles,
the field of view, transitions, zoom behaviours, interaction with
environment, controls and so on.  I then proposed several options before
going deeper into analysis and choosing one proposal that I thought
might work.  It took over a week and resulted in a 40-page tome but I
learnt enough about cameras to last me a lifetime.  I still have that
knowedge fresh in my mind when considering camera systems for Hellblade.

So based on what I knew already, I wrote a (thankfully) more brief
analysis on our internal wiki.  It wasn't written for anyone in
particular, more to help my own thought process.  It's sort of a
hang-over from my computer science days when we were forced to do
systems analysis.

I went into it this assuming that we would have a regular 3^rd^ person
camera like in DmC but the process of analysis lead me to a place I
wasn't expecting.  Here it is:

** Camera System Analysis**

**Objective**

I cannot stress this enough: **the gameplay style and levels we create
are wholly dependent on the camera system we decide upon.**

The camera system should support clear combat awareness and a feeling of
immersion. There are broadly speaking two camera systems to choose from:
a 3^rd^ person chase camera and a fixed-rail camera system plus many
hybrid systems in-between.

On all our projects other than KFC, cameras were a full-time job for a
programmer plus considerable work for design. As we do not have a spare
programmer and only one designer for Hellblade, the camera solution we
employ must be one that does not require a dedicated programmer or
onerous designer time to implement.

Another consideration is that once a camera system was implemented on
our previous projects, I had to take directorial control over the camera
placement, framing and editing throughout the game. This took an
enormous amount of time and focus away from other areas of the game and
I would like to avoid this going forward.

**Chase Camera System**

A single chase camera system that intelligently deals with enemies and
environment. Examples include DMC, RE4, Last of Us, Batman etc

**PROS**

-   Only one camera is built for the entire game.

-   Player has a high level of control over the camera.

-   Framing of the character can vary but is relatively close, helping
    you connect with the character.

-   Exploration of level is freely attainable with this kind of camera

-   Supports varied gameplay modes from fighting to exploration to
    stealth to shooting

 

**CONS**

-   Development can take a very long time to manage every eventuality

-   The player is typically required to control the camera system to
    play effectively (not an issue for hardcore players)

-   Vista shots that show off the environment cannot be done with this
    system

-   Staging of level is difficult as we don't know where the camera is
    looking at any point in time

-   Camera can get very messy during combat

 

**Examples**


https://www.youtube-nocookie.com/embed/P4YyGnGPFUc

https://www.youtube-nocookie.com/embed/BVD44uXuhls

https://www.youtube-nocookie.com/embed/V2rBzQTrpkU

**Fixed Rail Camera System**

Fixed camera are preset in maya or unreal to give a fixed and directed
view of the action. ICO, God of War, Kung Fu Chaos, Heavenly Sword.

**PROS**

-   Very specific control over what is framed in the scene giving a very
    cinematic feel

-   User never has to worry about the camera controls

-   Action can be directed very precisely to the camera

 

**CONS**

-   Every part of every level has to be designed for the camera to make
    sure camera doesn't swing, gimble-lock, get obscured etc

-   Exploration, stealth and so on is severely limited

-   Transitions from camera to camera or branching paths can be tricky
    to make feel right.

-   A huge amount of camera tweaking throughout development is needed on
    a scene by scene basis

-   Creating intimate camera shots can be a big challenge.

-   Suits very linear level design as backtracking involves running into
    the camera

 

**Examples**


https://www.youtube-nocookie.com/embed/a2-5_adukXI

https://www.youtube-nocookie.com/embed/oNbN-mh7Ero

https://www.youtube-nocookie.com/embed/ZeI9Zc71ChA 

**Hybrid Fixed/Chase Camera Systems**

A combination of fixed and chase cameras. Usually split to be chase for
combat and fixed for traversal. Examples include DMC4, Enslaved.

**PROS /CONS**

-   The best of both worlds or the worst of both worlds depending on
    your implementation

-   Requires the implementation of two camera systems and seamless
    blending between

 

**Examples**


 https://www.youtube-nocookie.com/embed/_lxtqYq5JT8

https://www.youtube-nocookie.com/embed/EYov8AL4TGU

**Directed Chase Camera**

This is a chase camera that points at the framing that you decide as a
player but that can be overridden at any point using camera controls.
Examples: I think uncharted 2 used this, and Mario 64 in places.

**PROS /CONS**

-   The best of both worlds or the worst of both worlds depending on
    your implementation

-   Requires the implementation of two camera systems and seamless
    blending between

 

**Examples**

https://www.youtube.com/embed/saF3BMAoBGA

**Vector Field Camera**

This is more of an idea I've had for a while rather than a proven
solution.  I imagine a 3D vector field covering all playable areas of a
level that contain position, direction, character offset and fov
parameters. The actual camera would interpolate between these vectors.
You could set the vectors by flying the free cam and positioning the
hero in-game until you have enough vectors to describe the whole space.

UE4 supports vector fields so I don't know if that is something that may
be repurposed to control cameras. Perhaps it's worth investigating.

**PROS /CONS**

-   Would support larger explorable areas unconstrained by spline paths.

-   Would require lots of prototyping and implementation

 

**Over-the-Shoulder Camera**

This is an over the shoulder view with controls more in common with
first person shooters than traditional third person views. It requires
that controls are mapped to support this mode and suits shoulder buttons
for man actions as you would have to release the right stick to press a
button. Examples include Dead Space and RE4.


**Examples**

https://www.youtube-nocookie.com/embed/WWki99kvrWk


**PROS **

-   Very immersive. you feel close to your character

-   Fewer collision issues as the closeness limits obstruction

-   Simpler implementation as it doesn't require as much "assistance" as
    chase cameras nor the arduous set up of fixed cameras.

-   Supports very cinematic transitions (like Enslaved's dutching and
    Dead Space's moments)

**CONS **

-   Turning to face enemies is clunky as controls must be
    character-relative rather than screen-relative.

-   Visibility of surrounding enemies is restricted so gameplay should
    limit these to a few.

-   Face buttons are less accessible which could present serious
    problems for combat.

 

**Additional Notes:**

A shoulder camera will have a radical effect on controls, level design
and enemy make-up, AI and combat and will take us into largely uncharted
ground.

**1st Person Camera**

There are few examples of this in melee games. There are simply too many
problems with the narrow visibility and not being able to read the
character attacks and reactions on screen clearly. Though it simplifies
some aspects of development, namely the fact that you don't need to
see/animate your character fully, there are far too many risks without
clear tangible benefits to the player for this to be a serious
consideration.

** Investigate**

-   There is a default chase camera in UE4. We should put this to the
    test in a test map to see its potential and limitations.

-   Can we re-use camera systems from any previous projects?

-   What about a shoulder camera? We should protoype and explore this?

-   Can vector fields or SHL systems be hooked up to the camera in UE4?
    Can this be done without code support to test the idea? What tools
    are available in UE4?

-   The DmC chase camera was very fully featured but i imagine it was
    massively over developed and unusable in a new UE4 code base?
    Confirm

-   Kung Fu Chaos had a maya-exported camera. This was fully controlled
    by the artists in maya. For this to work, the levels have to be
    extremely linear.  Discount because workflow should remain in UE4
    and limitations are too onerous.

 

**Considerations**

-   Hardcore players don't mind manual camera control but this comes
    with caveats that suggests lots of camera development:

    -   The camera must follow the action invisibly. e.g. when fighting
        an enemy/enemies, it should track them

    -   The camera must zoom in and out intelligently depending on
        number of surrounding enemies

    -   The camera must never swing rapidly or otherwise cause sickness

    -   The camera must deal with obstruction effectively

    -   Wide open spaces, corridors, slopes should have different
        framing and positioning

-   Our code resource is severely limited so the only obvious way we
    could implement an intelligent chase camera is to port it from one
    of our other games (DmC, Enslaved).  Based on initial
    investigations, this is not feasible without a lot of code
    refactoring.

-   Examples of fixed-camera games are few and far between. It seems to
    have fallen out of favour in the name of giving players the freedom
    to explore. God of War is probably the last example of such a camera
    system. It is risky to bet on it.

-   Shoulder cameras are used for exploration/shooting games and I can't
    think of good examples of melee games that use this viewpoint other
    than God Hand which great combat controls but had clunky movement
    controls. Doing a melee game with this viewpoint is a risk but could
    perhaps present an opportunity to innovate.

 

** Conclusion**

-   We should pursue and prototype the** shoulder camera** as the first
    port of call.

-   The shoulder cam has a far reaching consequences (effectively,
    you're making a very different game from DmC) but presents
    several **opportunities**:

    -   The viewpoint is unusual for melee games. All existing examples
        are from PC games/mods from devs that are traditionally 1st
        person devs.

    -   Translating the depth of combat of DmC and fighting games into
        this viewpoint will be innovative and could present a
        progressive direction for melee.

    -   The sense of immersion is directly comparable with the shift
        from RE1 to RE4 in both gameplay and cinematic moments.

    -   Traversal in this viewpoint can be more scripted and canned like
        in RE4 rather than platform based like in DmC/GoW.

-   There are several limitations to bear in mind:

    -   Large open arenas are more suited to 3rd person camera views
        like in DmC whereas shoulder view suits more corridor based
        environments

    -   Shoulder-based FOV limits surroundings so having lots of enemies
        surround you is out. Better to focus on fewer tougher enemies
        that approach from in front.

    -   Enemy AI would have to respect the players' limited viewpoint.

    -   Controls are may have to be dictated by shoulder buttons as face
        buttons are difficult to reach (this may kill the idea of a
        shoulder cam -- needs to be prototyped)

    -   Animation pace and realism will matter more as you are closer to
        the character.

So summing up, we simply don't have the resources to implemented most of
our usual options.  An over-the-shoulder camera is a more reasonable
option from a resource point of view but leaves many questions
unanswered when it comes to combat.  This became the top item to
prototype.

At the time this analysis was written, we didn't have *any* available
code time on the project.  Luckily Alexander Litinov had just joined the
team as THE designer and comes from a programming background.  He
prototyped the camera system in Unreal using its Blueprint system.  He
had done enough for us to play around and experiment with different
control options with different numbers of enemies.  I was delighted that
it seemed perfectly natural to use face buttons in this camera view. It
meant we could create a hardcore fighting set-up within an unusually
intimate camera view.  In a sense it felt a little more like a
one-on-one fighter than a 3^rd^ person one-on-many masher which is no
bad thing.

So unless something unforeseen derails us, an over-the-shoulder style
camera system it is.

We will be probably be covering our prototype phase in the next video
diary so there should be more details then.  Stay tuned.
