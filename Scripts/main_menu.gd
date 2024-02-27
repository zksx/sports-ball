extends Control

@onready var start_button = $Start as Button 

@onready var game_scene = preload("res://Scenes/world.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.button_down.connect(on_start_pressed)

func on_start_pressed():
	get_tree().change_scene_to_packed(game_scene)

func on_local_pressed():
	pass

func on_mult_pressed():
	pass
