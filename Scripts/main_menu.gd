extends Control

@onready var start_button = $Start as Button 

@onready var game_scene = preload("res://Scenes/world.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_start_pressed)

func on_start_pressed():
	get_tree().change_scene_to_packed(game_scene)
