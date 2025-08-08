extends Node

var stage : int = 1

### GENERATOR ###
@warning_ignore("unused_signal") signal increasePowerDrain(drainAmount : int)
@warning_ignore("unused_signal") signal decreasePowerDrain(drainAmount : int)
@warning_ignore("unused_signal") signal generatorHigh
@warning_ignore("unused_signal") signal generatorLow
#################

### DA RATZ ###
@warning_ignore("unused_signal") signal attackGenerator
@warning_ignore("unused_signal") signal resetSpawnTimer
###############

## AMMO BOX ##
@warning_ignore("unused_signal") signal refillAmmo
##############

## UI POPUP ##
@warning_ignore("unused_signal") signal hideUI

### ENEMY ###
@warning_ignore("unused_signal") signal playerHit
@warning_ignore("unused_signal") signal enemyStarting
@warning_ignore("unused_signal") signal enemyCrouching
@warning_ignore("unused_signal") signal enemyKilled
#############

### GAME STATE ###
@warning_ignore("unused_signal") signal lostGame
@warning_ignore("unused_signal") signal wonGame
# NOTE: the nextStage signal is essentially the pause signal
@warning_ignore("unused_signal") signal nextStage(stage)
##################

### RADIO ###
@warning_ignore("unused_signal") signal radioFinished
#############

### COMPUTER ###
@warning_ignore("unused_signal") signal unpauseStage(stage)
################
