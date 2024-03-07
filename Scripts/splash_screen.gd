extends TextureRect
var main_menu = preload("res://Scenes/main_menu.tscn")

@onready var timer = $Timer

func _process(_delta):
	if (timer.is_stopped()):
		get_tree().change_scene_to_packed(main_menu)
