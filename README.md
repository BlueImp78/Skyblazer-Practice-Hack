# Skyblazer-Practice-Hack
A practice oriented romhack for Skyblazer speedruns.
It has features such as an open map with all levels available, RNG value display, boss health display, reloading/advancing through checkpoints, and more. See below for full feature list.

## How to patch

- Apply the .ips patch to your vanilla Skyblazer(U) ROM with the included Lunar IPS program. 
- Enjoy.

## Features

- Skipped game intro and logos, title screen no longer fadeouts after not pressing anything for too long.

- No cutscenes, beating Raglan resets the room instead of playing the ending.

- The map is open and all levels are available. Enter the old man's shrines to switch to the next continent, enter the first one to go to the intro stage.
  
- The game's intro movie is skipped, and the title screen plays the song you'd hear if you watched it until the end.

- Level title cards are skipped for slight faster loads into them.

- After selecting a level, health/max health, magic, and selected magic are appropriately set based on which ones you should have by that point in the run.

- With the game paused, press SELECT to quit to world map, A to refill health and X to refill magic.

- Your life counter now display the RNG value as it changes.

- Inside boss rooms, your gems counter display the boss's health.

- At any point in the stage, press SELECT to reload your current checkpoint, restarting with the same health and magic values you had when you entered that room, as well as selected magic (magic buffers also work when reloading).

- If holding SELECT, press D-PAD Left or Right to previous or next checkpoint respectively (this wraps around, so going to the previous checkpoint while in the first room of a stage will put you at the boss room).

## Known Issues

- The boss health display is not accurate for bosses with multiple targets (with the exception of the wall boss).
  
- Mashing SELECT while the world map zooms in after selecting a stage can crash the game.

- The RNG doesn't display in the intro stage.
