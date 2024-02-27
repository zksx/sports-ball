class_name HumanController
extends PlayerController

@export var Controls : PlayerControls

func _physics_process(_delta) -> void:
	var movement_x_input = Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left") 
	var movement_y_input = Input.get_action_strength("p1_move_down") - Input.get_action_strength("p1_move_up")
	movement_command.execute(player, MovementCommand.Params.new(movement_x_input, movement_y_input ))

