class_name Player
extends CharacterBody2D

@onready var UAngle = $UAngle
@onready var SAngle = $SAngle
@onready var DAngle = $DAngle
@onready var p1 = $p1.global_position
@onready var p2 = $p2.global_position

@export var Ball : PackedScene
@export var Stats : PlayerStats
@export var speed = 200
@export var has_disc = false
@export var time = 0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	if Input.is_action_just_pressed("ui_accept") and has_disc:
		throw()
	elif Input.is_action_just_pressed("Curve") and has_disc:
		throw_curve()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	

func _on_disc_area_body_entered(body):
	if  body.name == "Ball":
		body.queue_free()
		has_disc = true
		print("Fired")

func throw():
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	var vector_angle = get_vector_angle()
	ball.launch(vector_angle * Stats.throw_speed)  
	
	has_disc = false

func throw_curve():
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	ball.curve(Stats.curve_weight)
	has_disc = false

func get_vector_angle():
	var vector_angle = SAngle.position

	if Input.is_action_pressed("UAngle"):
		vector_angle = UAngle.position

	elif Input.is_action_pressed("DAngle"):
		vector_angle = DAngle.position

	return vector_angle
