classDiagram
    GameModeBase <|-- LevelGameModeBase
    GameModeBase <|-- MainMenuGameMode

    %%namespace Gameplay {
        class MainMenuGameMode
        class LevelGameModeBase {
            AchievementsSubsystem
            WeatherSubsystem
        }
        class StoryGameMode {
            QuestSubsystem
        }
        class TutorialGameMode {
            TutorialSubsystem
        }
        class RaceGameMode
    %%}

    LevelGameModeBase <|-- RaceGameMode
    LevelGameModeBase <|-- StoryGameMode
    StoryGameMode <-- TutorialGameMode