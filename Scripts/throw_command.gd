class_name ThrowCommand
extends Command

func execute(player: Player, _data: Object = null) -> void:
	player.throw()
