class_name HumanController
extends PlayerController

var Controls : PlayerControls

func set_controls(player_controls):
	Controls = player_controls

func _physics_process(_delta) -> void:
	var movement_x_input = Input.get_action_strength(Controls.move_right) - Input.get_action_strength(Controls.move_left) 
	var movement_y_input = Input.get_action_strength(Controls.move_down) - Input.get_action_strength(Controls.move_up)
	var move_data = MovementCommand.Params.new(movement_x_input, movement_y_input )
	movement_command.execute(player, move_data )
