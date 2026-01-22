# TEST
# particle flame ~ ~ ~ 0 0 0 0 1 force
# particle flame ^0.7 ^ ^ 0 0 0 0 1 force
# particle flame ^-0.7 ^ ^ 0 0 0 0 1 force
# particle flame ^ ^0.7 ^ 0 0 0 0 1 force
# particle flame ^ ^-0.7 ^ 0 0 0 0 1 force

# Check for collisions with entities
execute positioned ~-.99 ~-.99 ~-.99 if entity @e[tag=!raycaster,dy=0] positioned ~.99 ~.99 ~.99 if entity @e[tag=!raycaster,dy=0] run tag @s add ray_hit

# Check for collisions with blocks
execute unless block ~ ~ ~ #exploding:ray_permeable run tag @s add ray_hit

execute as @s[tag=!ray_hit] unless block ^0.7 ^ ^ #exploding:ray_permeable run scoreboard players add @s RayHitL 1
execute as @s[tag=!ray_hit] unless block ^-0.7 ^ ^ #exploding:ray_permeable run scoreboard players add @s RayHitR 1
execute as @s[tag=!ray_hit] unless block ^ ^0.7 ^ #exploding:ray_permeable run scoreboard players add @s RayHitU 1
execute as @s[tag=!ray_hit] unless block ^ ^-0.7 ^ #exploding:ray_permeable run scoreboard players add @s RayHitD 1

# Check against previous block hits
execute as @s[tag=!ray_hit] if score @s RayHitL matches 1.. if score @s RayHitR matches 1.. run tag @s add hit_block_check
execute as @s[tag=!ray_hit,tag=!hit_block_check] if score @s RayHitU matches 1.. if score @s RayHitD matches 1.. run tag @s add hit_block_check

# Remove previous raycast history
scoreboard players remove @s RayHitL 1
scoreboard players remove @s RayHitR 1
scoreboard players remove @s RayHitU 1
scoreboard players remove @s RayHitD 1

# Keep block hitting scores above 0
execute if score @s RayHitL matches ..0 run scoreboard players reset @s RayHitL
execute if score @s RayHitR matches ..0 run scoreboard players reset @s RayHitR
execute if score @s RayHitU matches ..0 run scoreboard players reset @s RayHitU
execute if score @s RayHitD matches ..0 run scoreboard players reset @s RayHitD

# Decrease the number of steps remaining
scoreboard players remove @s RaycastSteps 1

# If block was hit
execute if entity @s[tag=ray_hit,tag=!hit_block_check] run function exploding:explode

# Recurse until we hit a block or run out of steps
execute as @s[tag=!ray_hit,tag=!hit_block_check,scores={RaycastSteps=1..}] positioned ^ ^ ^0.25 run function exploding:ray/move
