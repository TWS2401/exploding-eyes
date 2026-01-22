##as @a[Team=Runners]

execute if data entity @s {Health:0.0f} run return fail

# Initialize steps
scoreboard players set @s RaycastSteps 400

tag @s remove hit_block
tag @s remove hit_block_check
tag @s remove hit_player

# Move the ray
execute at @s anchored eyes run function exploding:ray/move

# Check for blocks
scoreboard players set @s RaycastSteps 800

scoreboard players reset @s RayHitL
scoreboard players reset @s RayHitR
scoreboard players reset @s RayHitU
scoreboard players reset @s RayHitD

execute as @s[tag=hit_block_check] at @s anchored eyes run function exploding:ray/movefine

# If nothing was hit
execute as @s[tag=!hit_block] at @s anchored eyes positioned ^ ^ ^100 run function exploding:explode
