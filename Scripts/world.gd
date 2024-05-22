extends Node

var main_menu = preload("res://Scenes/main_menu.tscn")

var p1_set_count = 0
var p2_set_count = 0

var serve_left = -100
var serve_right = 100
var serve_dir = serve_left

var players_should_reset = false
var disc_in_play = true
var one_time = false
var players_in_place = 0

var goal_dir = 1


@export var Ball = load("res://Scenes/ball.tscn")
@onready var Server = $Server
@onready var players = $Court/Players
@onready var starting_locs = $Court/StartLocations
@onready var bot_wall = $Court/BotWall

@onready var anim_player = $AnimationPlayer

@onready var starting_loc = $Court/StartLocations/P1StartLocation
@onready var ScoreBoard = $ScoreBoard

@onready var Camera = $Path2D/PathFollow2D/Camera2D
@onready var PathFollow = $Path2D/PathFollow2D

var camera_move = false
var player_count = 0

func _ready():
	player_count = players.get_children().size()
	ball_spawn()

func _process(_delta):
	game_check()
	set_check()
	time_check()

func _physics_process(delta):
	if players_should_reset:
		player_reset(delta)
		
	if players_in_place == player_count:
		serve_check(serve_dir)
		for player in players.get_children(): 
			var human_controller = HumanController.new(player)
			human_controller.set_controls(player.Controls)
			player.set_controller(human_controller)
			
		players_in_place = 0
		
	# check if the camera should move
	if camera_move:
	
		if !one_time:
			# increment path follower ratio 
			PathFollow.progress_ratio += 0.08 * goal_dir
			
		else:
			PathFollow.progress_ratio -= 0.025 * goal_dir
		
			
		if PathFollow.progress_ratio >= (0.75 * goal_dir) and !one_time:
			await get_tree().create_timer(1).timeout
			one_time = true
			
		if   PathFollow.progress_ratio > 0.49 and PathFollow.progress_ratio < 0.51:
			PathFollow.progress_ratio = 0.50
			camera_move = false
			one_time = false


func ball_spawn():
	var ball = Ball.instantiate()
	add_child(ball)
	ball.serve()


func game_check():
	if( ScoreBoard.get_player_1_score() >= 3):

		p1_set_count += 1
		ScoreBoard.player_1_set_win()
		ScoreBoard.reset_scores()

	elif (ScoreBoard.get_player_2_score() >= 3):

		p2_set_count += 1
		ScoreBoard.player_2_set_win()
		ScoreBoard.reset_scores()


func player_reset(_delta):
	var starting_loc_pos
	var index = 0
	var player_starting_locs = starting_locs.get_children()

	for player in players.get_children():
		
		starting_loc_pos = player_starting_locs[index].get_global_position()
		
		player.set_controller(AiController.new(player))
		
		player.force_move(starting_loc_pos)
		
		index += 1

	players_should_reset = false


func serve_check(ser_dir):
	Server.serve(ser_dir)
	disc_in_play = true


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
		var disc = body
		var goal = $Court/LeftGoal
		
		await play_goal_sequence(disc, goal)
		ScoreBoard.player_2_scored()
		set_flags_for_goal()


func _on_player_2_goal_body_entered(body):
	if body.is_in_group("disc"):
		var disc = body
		var goal = $Court/RightGoal
		

		await play_goal_sequence(disc, goal)
		ScoreBoard.player_1_scored()
		set_flags_for_goal()


func play_goal_sequence(disc, goal):
	move_camera_for_goal(goal)
	disc.dead_ball()
	Camera.shake()
	await goal.play_goal()
	disc.queue_free()


func set_flags_for_goal():
	players_should_reset = true
	disc_in_play = false
	serve_dir = serve_right

func move_camera_for_goal(goal):
	if goal == $Court/LeftGoal:
		goal_dir = -1
	else:
		goal_dir = 1
		
	camera_move = true
	
func time_check():
	# check if the time is at zero for the scoreboard
	if int(ScoreBoard.get_time()) == 0:
	
		# check if p1 has the greater score
		if ScoreBoard.get_player_1_score() > ScoreBoard.get_player_2_score():
			p1_set_count += 1
			ScoreBoard.player_1_set_win()
			set_flags_for_goal()
			
		# otherwise give p2 the set
		else:
			p2_set_count += 1
			ScoreBoard.player_2_set_win()
			set_flags_for_goal()
			
		ScoreBoard.start_time(60)
		
