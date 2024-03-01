class_name PlayerController
extends Node

var player: Player 

var movement_command := MovementCommand.new()

func _init(human_player: Player) -> void:
	self.player = human_player
