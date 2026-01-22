# TEST
# particle flame ~ ~ ~ 0 0 0 0 1 force
# particle flame ^0.35 ^ ^ 0 0 0 0 1 force
# particle flame ^-0.35 ^ ^ 0 0 0 0 1 force
# particle flame ^ ^0.35 ^ 0 0 0 0 1 force
# particle flame ^ ^-0.35 ^ 0 0 0 0 1 force

# Check for collisions with blocks
execute unless block ~ ~ ~ #exploding:ray_permeable run tag @s add hit_block

execute as @s[tag=!hit_block] unless block ^0.35 ^ ^ #exploding:ray_permeable run scoreboard players add @s RayHitL 1
execute as @s[tag=!hit_block] unless block ^-0.35 ^ ^ #exploding:ray_permeable run scoreboard players add @s RayHitR 1
execute as @s[tag=!hit_block] unless block ^ ^0.35 ^ #exploding:ray_permeable run scoreboard players add @s RayHitU 1
execute as @s[tag=!hit_block] unless block ^ ^-0.35 ^ #exploding:ray_permeable run scoreboard players add @s RayHitD 1

# Check against previous block hits
execute as @s[tag=!hit_block] if score @s RayHitL matches 1.. if score @s RayHitR matches 1.. run tag @s add hit_block
execute as @s[tag=!hit_block] if score @s RayHitU matches 1.. if score @s RayHitD matches 1.. run tag @s add hit_block

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
execute if entity @s[tag=hit_block] run function exploding:explode

# Recurse until we hit a block or run out of steps
execute as @s[tag=!hit_block,scores={RaycastSteps=1..}] positioned ^ ^ ^0.125 run function exploding:ray/movefine
