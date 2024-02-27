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

@export var Ball : PackedScene
@onready var Server = $Server
@onready var players = $Court/Players
@onready var starting_locs = $Court/StartLocations
@onready var bot_wall = $Court/BottomWall

@onready var anim_player = $AnimationPlayer

@onready var starting_loc = $Court/StartLocations/P1StartLocation

func _ready():
	ball_spawn()

func _process(delta):
	$Court/CanvasLayer/ScoreKeeper/HBoxContainer/player1_score.text = str(p1_score)
	$Court/CanvasLayer/ScoreKeeper/HBoxContainer/player2_score.text = str(p2_score)

	game_check()
	set_check()

	if reset:
		player_reset(delta)


func serve_check(ser_dir):
	Server.serve(ser_dir)
	in_play = true


func _on_player_1_goal_body_entered(body):
	if body.is_in_group("disc"):
		body.queue_free()
		p2_score += 1
		reset = true
		in_play = false
		serve_dir = serve_left


func _on_player_2_goal_body_entered(body):
	if body.is_in_group("disc"):
		body.queue_free()
		p1_score += 1
		reset = true
		in_play = false
		serve_dir = serve_right


func game_check():
	if( p1_score >= 3):
		p1_score = 0
		p2_score = 0
		p1_set_count += 1

	elif (p2_score >= 3):
		p1_score = 0
		p2_score = 0
		p2_set_count += 1


func set_check():
	if (p1_set_count >= 2):
		print("p1_wins")
		get_tree().change_scene_to_packed(main_menu)
		
	elif(p2_set_count >= 2):
		print("p2_wins")
		get_tree().change_scene_to_packed(main_menu)


func ball_spawn():
	var ball = Ball.instantiate()
	add_child(ball)
	ball.serve()


func player_reset(delta):
	var index = 0
	var player_amount = players.get_child_count()
	var start_loc = starting_loc.get_global_position()
	
	

	for player in players.get_children():

		# 1.
		print("setting AI")
		player.set_controller(AiController.new(player))
		
		# need to gather player starting locations
		
		
		# 2
		player.force_move(start_loc)
		

	reset = false
