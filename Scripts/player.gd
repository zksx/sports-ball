class_name Player
extends CharacterBody2D

@onready var UAngle = $UAngle
@onready var SAngle = $SAngle
@onready var DAngle = $DAngle

@export var Ball : PackedScene
@export var Controls : PlayerControls
@export var Stats : PlayerStats

@export var speed = 200
@export var time = 0

var has_disc = false

func get_input():
	var input_direction = Input.get_vector(Controls.move_left, Controls.move_right, 
	Controls.move_up,Controls.move_down)
	
	velocity = input_direction * Stats.move_speed
	if Input.is_action_just_pressed(Controls.throw) and has_disc:
		throw()
	elif Input.is_action_just_pressed(Controls.curve) and has_disc:
		throw_curve(Controls.player_index)

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_disc_area_body_entered(body):
	if  body.name == "Ball":
		body.queue_free()
		self.has_disc = true

func throw():
		
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	var vector_angle = get_vector_angle()
	ball.launch(vector_angle * Stats.throw_speed  )
	print(vector_angle * Stats.throw_speed  )  
	
	self.has_disc = false

func throw_curve(facing):
	var facing_dir = 1
	if facing == 1:
		facing_dir = -1
	
	# create ball object
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	var throw_dir = get_throw_direction()
	var curve_path = Stats.curve_weight * throw_dir
	
	ball.curve(curve_path,facing_dir)
	self.has_disc = false

func get_vector_angle():
	var vector_angle = SAngle.position

	if Input.is_action_pressed("ui_up"):
		vector_angle = UAngle.position

	elif Input.is_action_pressed("ui_down"):
		vector_angle = DAngle.position

	return vector_angle

func get_throw_direction():
	var throw_direction = 1

	if Input.is_action_pressed("ui_up"):
		throw_direction = -1

	elif Input.is_action_pressed("ui_down"):
		throw_direction = 1

	return throw_direction
