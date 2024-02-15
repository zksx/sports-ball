class_name Player
extends CharacterBody2D
@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var audio_player = $throw_sound

@onready var Sprite = $Sprite2D

@onready var Angles = $Angles
@onready var UAngle = $Angles/UAngle
@onready var SAngle = $Angles/SAngle
@onready var DAngle = $Angles/DAngle

@onready var default_idle = Vector2.RIGHT

@export var Ball : PackedScene
@export var Controls : PlayerControls
@export var Stats : PlayerStats

@export var speed = 200
@export var time = 0

var has_disc = false

func _ready():
	if Controls.player_index == 2:
		Stats.curve_speed = Stats.curve_speed * -1
		
		default_idle = Vector2.LEFT
		
		for angle in Angles.get_children():
			angle.position.x = angle.position.x * -1


func get_input():
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength(	Controls.move_right) - Input.get_action_strength(Controls.move_left)
	input_vector.y = Input.get_action_strength(Controls.move_down) - Input.get_action_strength(	Controls.move_up)
	input_vector = input_vector.normalized()
	play_anims(input_vector)

	velocity = input_vector * Stats.move_speed
	if Input.is_action_just_pressed(Controls.throw) and has_disc:
		
		var ball = spawn_ball()
		var vec_angle = get_vector_angle()
		
		print(vec_angle)
		print(Stats.throw_speed)
		
		ball.launch(vec_angle * Stats.throw_speed)
		
		audio_player.play()
		
		self.has_disc = false


	elif Input.is_action_just_pressed(Controls.curve) and has_disc:
		var ball = spawn_ball()
		var throw_dir = get_throw_direction()
		ball.start_curve(Stats.curve_weight * throw_dir, Stats.curve_speed * 2)
		
		audio_player.play()
		
		self.has_disc = false


func _physics_process(_delta):
	get_input()
	move_and_slide()


func _on_disc_area_body_entered(body):
	if  body.is_in_group("disc"):
		body.queue_free()
		self.has_disc = true


func get_vector_angle():
	var vector_angle = SAngle.position

	if Input.is_action_pressed(Controls.move_up):
		vector_angle = UAngle.position

	elif Input.is_action_pressed(Controls.move_down):
		vector_angle = DAngle.position

	return vector_angle


func get_throw_direction():
	var throw_direction = 1

	if Input.is_action_pressed(Controls.move_up):
		throw_direction = -1

	elif Input.is_action_pressed(Controls.move_down):
		throw_direction = 1

	return throw_direction


func spawn_ball():
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	return ball


func play_anims(input_vector):

	if input_vector != Vector2.ZERO:
		anim_tree["parameters/conditions/is_moving"] = true
		anim_tree["parameters/conditions/is_idle"] = false

	else:
		anim_tree["parameters/conditions/is_moving"] = false
		anim_tree["parameters/conditions/is_idle"] = true

	anim_tree["parameters/Run/blend_position"] = input_vector
	anim_tree["parameters/Idle/blend_position"] = default_idle

func p1_reset():
		anim_player.play("reset_p1")
