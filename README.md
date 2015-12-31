# COCPrototype

Drag-to-slash-demon iOS game (prototype)
* drag to move a samurai around the field
* drag near demons to slash them, and to increase the magic gauge
* but not too fast, beware the people, don't slash them!
* if the magic gauge is filled, double tap for rage mode, in this mode samurai will not interact with people, feel free to move around at full speed!


## About Code ##
* Implemented using Objective-C and SpriteKit
* Core
 * GameScene.m - main game loop
 * GameStageFlow.txt - create game map (monster & people)
   * "1" => monster, "-1" => people, "time,3.0" => wait 3s before dispatch next round
 * SoundManager.m - various sound service in game
 * MonsterManager.m - interpret GameStageFlow.txt to dispatch entity objects
  * COCStageFileReader.m - read the file
  * COCStageCharacterBlock.m - translate from text to array
  * COCTimer.m - timer to spawn entities
* Entity
 * COCCharacter.m - protocol for all entities (node), children must implement update: and characterDie:
 * __Node.m - all entities in game, load global assets and update their movement
* Decoration
 * ScrollingBackground.m - infinitely looping background image
 * SKBlade.m - fruit ninja-like blade's glimmering effect
