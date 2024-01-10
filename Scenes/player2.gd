extends CharacterBody2D

@export var speed = 200

func get_input():
	var input_direction = Input.get_vector("player2_left", "player2_right", "player2_up", "player2_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
