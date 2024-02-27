class_name PlayerController
extends Node

var player: Player 

var movement_command := MovementCommand.new()

func _init(player: Player) -> void:
	self.player = player
