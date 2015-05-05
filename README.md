# lua-gen
## work in progress
A playground for experiments in dungeon generation utilizing principles of Boid flocking for placement of rooms using Lua & LOVE2D.

## The process
Each individual room is treated as an individual Boid, then all rooms are placed in a random overlapping distribution within a rectangular region.
Each room uses Boid flocking behavior to space itself from other rooms until every room is spaced far enough.
