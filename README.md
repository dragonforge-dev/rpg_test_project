A Godot 3D RPG Test Project for learning and trying out new ideas.

# File Organization #
In the root folder we currently have the main scene and its atatched script.

## Addons ##
All addons for the Godot Editor. Not for export.

## Assets ##
All creative assets that are imported.

### Art ###
All visual art assets. (**NOTE:** These are all currently in the .gitignore.)

#### Characters ####
All Player character models.

#### Dungeon ####
All level-building dungeon assets.

#### Items ####
All individual item models.

#### Monsters ####
All monster assets (currently empty).

### Sound ###
All audio art assets.

#### sfx ####
Sound effects.
- Environment
    - Pickup Sounds for Coins
    - Pickup Sounds for Metal Objects

## Environment ##
All PackedScene objects and scripts that have been made for the environment. (Currently all dungeon assets.)

### Floors ###

### Loot ###
Objects that can be picked up by the player and added to inventory.

### Rooms ###
Rooms that can be combined together to make levels.

### Walls ###

## Mobs ##

### Characters ###
All player character assets and scripts.

#### Scripts ####
actions.gd          - Handles most _unhandled_event events.
animations.gd       - Handles all animations.
player_character.gd - Main script for the player.

#### Scenes ####
barbarian.tscn      - Barbarian Player Character.
follow_camera.tscn  - A simple follow camera implemented and atatched to all the player models.
knight.tscn         - Knight Player Character.
mage.tscn           - Mage Player Character.

### Monsters ###
Currently Empty

## Utilities ##
Currently all things that can be excluded from export (I believe.)

### Editor ###
Import scripts for floors, walls, and treasure.

### Test ###
Tools for testing that I do not want players to have access to.

# Assets #
## 3D Models ##
### Characters ###
[Adventurers Character Pack](https://kaylousberg.itch.io/kaykit-adventurers) by [Kay Lousberg](https://kaylousberg.com/) (More cool stuff on [Pateron](https://www.patreon.com/kaylousberg).)

### Environment ###
[Dungeon Remastered](https://kaylousberg.itch.io/kaykit-dungeon-remastered) by [Kay Lousberg](https://kaylousberg.com/) ([Pateron](https://www.patreon.com/kaylousberg))

# Sound #
## Sound Effects ##
[Medieval Fantasy Game Sound Effects](https://magicsoundeffects.itch.io/medieval-fantasy-game-sound-effects) by [Magical Sound Effects](https://magicsoundeffects.itch.io/)
## Music ##
