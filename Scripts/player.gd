class_name Player
extends CharacterBody2D

@onready var UAngle = $UAngle
@onready var SAngle = $SAngle
@onready var DAngle = $DAngle

@export var Ball : PackedScene
@export var Stats : PlayerStats
@export var speed = 200
@export var time = 0

var has_disc = false

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * Stats.move_speed
	if Input.is_action_just_pressed("throw") and has_disc:
		throw()
	elif Input.is_action_just_pressed("curve") and has_disc:
		throw_curve()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_disc_area_body_entered(body):
	if  body.name == "Ball":
		body.queue_free()
		self.has_disc = true
		print("Fired")

func throw():
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	var vector_angle = get_vector_angle()
	ball.launch(vector_angle * Stats.throw_speed)  
	
	self.has_disc = false

func throw_curve():
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	ball.curve(Stats.curve_weight)
	self.has_disc = false

func get_vector_angle():
	var vector_angle = SAngle.position

	if Input.is_action_pressed("ui_up"):
		vector_angle = UAngle.position

	elif Input.is_action_pressed("ui_down"):
		vector_angle = DAngle.position

	return vector_angle
