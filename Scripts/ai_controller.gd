class_name AiController
extends PlayerController

var _init_time: int = 0
var move_location

func ready():
	_init_time = Time.get_ticks_msec()


func _physics_process(delta) -> void:
	pass

func ai_move(data):
	movement_command.execute(player, MovementCommand.Params.new(data.x, data.y ))
