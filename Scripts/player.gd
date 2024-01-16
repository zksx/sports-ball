extends CharacterBody2D

@export var Ball : PackedScene

@export var speed = 200
@export var has_disc = false

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	if Input.is_action_just_pressed("ui_accept") and has_disc:
		throw()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_disc_area_body_entered(body):
	if  body.name == "Ball":
		body.queue_free()
		has_disc = true
		print("Fired")

func throw():
	var ball = Ball.instantiate()
	ball.transform = $Angle.global_transform
	owner.add_child(ball)
	var ang = Vector2.ZERO
	var angle = ang.angle_to_point($Angle.position)
	print(angle)
	ball.launch($Angle.position * 5)
	has_disc = false
