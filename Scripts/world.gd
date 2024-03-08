extends Node

var gameManager = preload("res://Scripts/GameManager.tres")
var main_menu = preload("res://Scenes/main_menu.tscn")

var p1_score = 0
var p2_score = 0

var p1_set_count = 0
var p2_set_count = 0

var serve_left = -100
var serve_right = 100
var serve_dir = serve_left

var reset = false
var in_play = true
var players_in_place = 0

@export var Ball : PackedScene
@onready var Server = $Server
@onready var players = $Court/Players
@onready var starting_locs = $Court/StartLocations
@onready var bot_wall = $Court/BottomWall

@onready var anim_player = $AnimationPlayer

@onready var starting_loc = $Court/StartLocations/P1StartLocation

func _ready():
	ball_spawn()

func _process(_delta):
	$Court/CanvasLayer/ScoreKeeper/HBoxContainer/player1_score.text = str(p1_score)
	$Court/CanvasLayer/ScoreKeeper/HBoxContainer/player2_score.text = str(p2_score)

	game_check()
	set_check()

func _physics_process(delta):
	if reset:
		player_reset(delta)
		
	if players_in_place == 2:
		serve_check(serve_dir)
		for player in players.get_children(): 
			var human_controller = HumanController.new(player)
			human_controller.set_controls(player.Controls)
			player.set_controller(human_controller)
			
		players_in_place = 0


func ball_spawn():
	var ball = Ball.instantiate()
	add_child(ball)
	ball.serve()


func game_check():
	if( p1_score >= 3):
		p1_score = 0
		p2_score = 0
		p1_set_count += 1

	elif (p2_score >= 3):
		p1_score = 0
		p2_score = 0
		p2_set_count += 1


func player_reset(_delta):
	var starting_loc_pos
	var index = 0
	var player_starting_locs = starting_locs.get_children()

	for player in players.get_children():
		
		starting_loc_pos = player_starting_locs[index].get_global_position()
		
		player.set_controller(AiController.new(player))
		
		player.force_move(starting_loc_pos)
		
		index += 1

	reset = false


func serve_check(ser_dir):
	Server.serve(ser_dir)
	in_play = true


func set_check():
	if (p1_set_count >= 2):
		print("p1_wins")
		get_tree().change_scene_to_packed(main_menu)
	
	elif(p2_set_count >= 2):
		print("p2_wins")
		get_tree().change_scene_to_packed(main_menu)


func _on_player_player_set():
	players_in_place += 1


func _on_player_2_player_set():
	players_in_place += 1


func _on_player_1_goal_body_entered(body):
	if body.is_in_group("disc"):
		var goal1_anim = $Court/LeftGoal/AnimationPlayer
		var audio = $Court/LeftGoal/AudioStreamPlayer2D
		
		body.is_alive = false
		body.is_moving = false
		body.velocity = Vector2.ZERO
		
		goal1_anim.play("score")
		audio.play()
		await goal1_anim.animation_finished
		body.queue_free()
		
		p2_score += 1
		reset = true
		in_play = false
		serve_dir = serve_left


func _on_player_2_goal_body_entered(body):
	if body.is_in_group("disc"):
		var goal2_anim = $Court/RightGoal/AnimationPlayer
		var audio = $Court/RightGoal/AudioStreamPlayer2D
		
		body.is_alive = false
		body.is_moving = false
		body.velocity = Vector2.ZERO
		
		goal2_anim.play("score")
		audio.play()
		await goal2_anim.animation_finished
		body.queue_free()
		
		p1_score += 1
		reset = true
		in_play = false
		serve_dir = serve_right
