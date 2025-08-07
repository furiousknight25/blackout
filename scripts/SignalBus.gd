extends Node

### GENERATOR ###
@warning_ignore("unused_signal") signal increasePowerDrain(drainAmount : int)
@warning_ignore("unused_signal") signal decreasePowerDrain(drainAmount : int)
#################

### DA RATZ ###
@warning_ignore("unused_signal") signal attackGenerator
@warning_ignore("unused_signal") signal resetSpawnTimer
###############

## AMMO BOX ##
@warning_ignore("unused_signal") signal refillAmmo
##############


### ENEMY ###
@warning_ignore("unused_signal") signal playerHit
@warning_ignore("unused_signal") signal enemyStarting
@warning_ignore("unused_signal") signal enemyCrouching
@warning_ignore("unused_signal") signal enemyKilled
#############

### GENERATOR ###
@warning_ignore("unused_signal") signal generatorHigh
@warning_ignore("unused_signal") signal generatorLow
#################

### GAME STATE ###
@warning_ignore("unused_signal") signal lostGame
@warning_ignore("unused_signal") signal wonGame
##############
