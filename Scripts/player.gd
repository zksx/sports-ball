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

@onready var _controller_container = $ControllerContainer
@onready var default_idle = Vector2.RIGHT

@export var Ball : PackedScene
@export var Controls : PlayerControls
@export var Stats : PlayerStats
@export var speed = 200
@export var time = 0

var _controller = PlayerController

var destination_loc
var should_move = false
var has_disc = false
var _horizontal_input: float = 0
var _vertical_input: float = 0

signal player_set

func _ready():
	var human_controller = HumanController.new(self)
	human_controller.set_controls(self.Controls)
	set_controller(human_controller)
	
	if Controls.player_index == 2:
		Stats.curve_speed = Stats.curve_speed * -1
		
		default_idle = Vector2.LEFT
		
		for angle in Angles.get_children():
			angle.position.x = angle.position.x * -1


func _physics_process(delta):
	if should_move:
		move_to(delta)

	get_input(delta)
	handle_movement(delta)


func force_move(destination):
	destination_loc = destination
	should_move = true


func get_input(_delta):
	if Input.is_action_just_pressed(Controls.throw) and has_disc:
		
		var ball = spawn_ball()
		var vec_angle = get_vector_angle()
		ball.launch(vec_angle * Stats.throw_speed)
		self.has_disc = false


	elif Input.is_action_just_pressed(Controls.curve) and has_disc:
		var ball = spawn_ball()
		var throw_dir = get_throw_direction()
		ball.start_curve(Stats.curve_weight * throw_dir, Stats.curve_speed * 2)
		self.has_disc = false


func get_throw_direction():
	var throw_direction = 1

	if Input.is_action_pressed(Controls.move_up):
		throw_direction = -1

	elif Input.is_action_pressed(Controls.move_down):
		throw_direction = 1

	return throw_direction


func get_vector_angle():
	var vector_angle = SAngle.position

	if Input.is_action_pressed(Controls.move_up):
		vector_angle = UAngle.position

	elif Input.is_action_pressed(Controls.move_down):
		vector_angle = DAngle.position

	return vector_angle


func handle_movement(_delta):
	var input_vector = Vector2.ZERO

	input_vector.x = _horizontal_input
	input_vector.y = _vertical_input
	input_vector = input_vector.normalized()
	
	play_anims(input_vector)
	velocity = input_vector * Stats.move_speed


func move(value: MovementCommand.Params) -> void:
	_horizontal_input = value.x_input
	_vertical_input = value.y_input
	move_and_slide()

func move_to(delta):
	if destination_loc != null:
		
		var distance = self.global_position.distance_to(destination_loc)
		var max_speed = (distance / delta)
		var direction = self.global_position.direction_to(destination_loc)
		var player_loc = self.get_global_position()
		var move_data = MovementCommand.Params.new(direction.x, direction.y)
		
		self.velocity = direction * minf(speed, max_speed)
		self.move(move_data)

		if destination_loc == player_loc:
			should_move = false
			player_set.emit()


func play_anims(input_vector):
	if input_vector != Vector2.ZERO:
		anim_tree["parameters/conditions/is_moving"] = true
		anim_tree["parameters/conditions/is_idle"] = false

	else:
		anim_tree["parameters/conditions/is_moving"] = false
		anim_tree["parameters/conditions/is_idle"] = true

	anim_tree["parameters/Run/blend_position"] = input_vector
	anim_tree["parameters/Idle/blend_position"] = default_idle


func set_controller(controller: PlayerController) -> void:
	# Delete all previous controllers
	for child in _controller_container.get_children():
		child.queue_free()

	_controller = controller
	_controller_container.add_child(_controller)


func spawn_ball():
	var ball = Ball.instantiate()
	ball.transform = SAngle.global_transform
	owner.add_child(ball)
	
	return ball


func _on_disc_area_body_entered(body):
	if  body.is_in_group("disc"):
		body.queue_free()
		self.has_disc = true
