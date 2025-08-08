extends Node

var stage : int = 1

### GENERATOR ###
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal increasePowerDrain(drainAmount : int)
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal decreasePowerDrain(drainAmount : int)
#NOTE: Connects from: generator
#NOTE: Connects to: enemy
@warning_ignore("unused_signal") signal generatorHigh
#NOTE: Connects from: generator
#NOTE: Connects to: enemy
@warning_ignore("unused_signal") signal generatorLow
#################

### DA RATZ ###
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal attackGenerator
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal resetSpawnTimer
###############

## AMMO BOX ##
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal refillAmmo
##############

## UI POPUP ##
#NOTE: Connects from: 
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal hideUI

### ENEMY ###
#NOTE: Connects from: enemy
#NOTE: Connects to: player
@warning_ignore("unused_signal") signal playerHit
#NOTE: Connects from: enemy
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal enemyStarting
#NOTE: Connects from: enemy
#NOTE: Connects to: 
@warning_ignore("unused_signal") signal enemyCrouching
#NOTE: Connects from: enemy
#NOTE: Connects to: player
@warning_ignore("unused_signal") signal enemyKilled
#############

### GAME STATE ###
#NOTE: Connects from: player
#NOTE: Connects to: radio, computer, enemy, powerEaterManager, generator, gameStateManager
@warning_ignore("unused_signal") signal lostGame
#NOTE: Connects from: gameStateManager
#NOTE: Connects to: N/A
@warning_ignore("unused_signal") signal wonGame
#NOTE: Connects from: computer
#NOTE: Connects to: radio, computer, enemy, powerEaterManager, generator, gameStateManager
@warning_ignore("unused_signal") signal nextStage(stage)
##################

### RADIO ###
#NOTE: Connects from: radio
#NOTE: Connects to: computer
@warning_ignore("unused_signal") signal radioFinished
#############

### COMPUTER ###
#NOTE: Connects from computer
#NOTE: Connects to radio, computer, enemy, powerEaterManager, generator
@warning_ignore("unused_signal") signal unpauseStage(stage)
################
