class_name Player
extends CharacterBody2D
@onready var anim_player = $Sprite2D/AnimationPlayer
@onready var audio_player = $throw_sound

@onready var UAngle = $UAngle
@onready var SAngle = $SAngle
@onready var DAngle = $DAngle

@export var Ball : PackedScene
@export var Controls : PlayerControls
@export var Stats : PlayerStats

@export var speed = 200
@export var time = 0

var has_disc = false

func _ready():
	if Controls.player_index == 2:
		Stats.throw_speed = Stats.throw_speed * -1
		Stats.curve_speed = Stats.curve_speed * -1

func get_input():
	var input_direction = Input.get_vector(Controls.move_left, Controls.move_right, 
	Controls.move_up,Controls.move_down)
	
	play_run_anim(input_direction)

	velocity = input_direction * Stats.move_speed
	if Input.is_action_just_pressed(Controls.throw) and has_disc:
		
		var ball = spawn_ball()
		var vec_angle = get_vector_angle()
		
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
	if  body.name == "Ball":
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

func play_run_anim(input_direction):

	if input_direction == Vector2.RIGHT:
		anim_player.play("run_right")

	elif input_direction == Vector2.LEFT:
		anim_player.play("run_left")

	elif input_direction == Vector2.DOWN:
		anim_player.play("run_down")

	elif input_direction == Vector2.UP:
		anim_player.play("run_up")
		
	elif input_direction == Vector2(1,1):
		anim_player.play("run_up")

	else:
		anim_player.play("idle")
