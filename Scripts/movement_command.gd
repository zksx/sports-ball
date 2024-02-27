class_name MovementCommand
extends Command

class Params:
	var x_input: float
	var y_input: float
	
	func _init(hor_input: float, vert_input: float) -> void:
		self.x_input = hor_input
		self.y_input = vert_input
	
func execute(player: Player, data: Object = null) -> void:
	if data is Params:
		player.move(data)
