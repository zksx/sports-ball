extends CharacterBody2D

@export var speed = 200

@export var has_disc = false

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

func sayHi():
	print("hey")

func _on_disc_area_body_entered(body):
	if  body.name == "Ball":
		body.queue_free()
		has_disc = true
		
		# Change state to a state where the player has the disc
