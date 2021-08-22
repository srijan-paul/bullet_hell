# Bullet Hell
A bullet hell game written in Lua, using the LÖVE game framework.

I'm using LOVE2D for rendering, and everything else has been done more or less from scratch.
You can find Entity management system under `prefabs/`, the particle system under `particles/`, 
and the collision resolution and physics systems in `world/`.

The game is currently a work in progress, but it' still in a playable state.

Here is a small sample:
![Demo](https://github.com/srijan-paul/srijan-paul/blob/main/bullet_hell.gif)



**Features (so far):**
- Random dungeon generation, PCG'ed levels and rooms.
- Different kinds of enemies on different biomes.
- Abilities/skills to choose from.
- Blast through enemies with a whole suite of weapons.
