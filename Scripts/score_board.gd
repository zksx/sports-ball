extends Node2D

@onready var player_1_score = $Sprite2D/ScoreKeeper/HBoxContainer/player1_score
@onready var player_2_score = $Sprite2D/ScoreKeeper/HBoxContainer/player2_score
@onready var player_1_set_light = $Sprite2D/ScoreKeeper/player1_set_light
@onready var player_2_set_light = $Sprite2D/ScoreKeeper/player2_set_light
@onready var time = $Sprite2D/ScoreKeeper/HBoxContainer2/time

@onready var timer = $Timer

var p1_points = 0
var p2_points = 0
var p1_set_points = 0
var p2_set_points = 0


func player_1_scored():
	p1_points += 1
	player_1_score.text = str(p1_points)

func player_2_scored():
	p2_points += 1
	player_2_score.text = str(p2_points)

func reset_scores():
	p1_points = 0
	p2_points = 0
	player_1_score.text = str(0)
	player_2_score.text = str(0)
	
	start_time(60)


func player_1_set_win():
	p1_set_points += 1
	player_1_set_light.set_visible(true)

func player_2_set_win():
	p2_set_points += 1
	player_2_set_light.set_visible(true)


func get_player_1_set_score():
	return p1_set_points
	

func get_player_2_set_score():
	return p2_set_points
	

func get_player_1_score():
	return p1_points
	

func get_player_2_score():
	return p2_points


func start_time(secs):
	timer.start(secs)


func get_time():
	return str(int(timer.get_time_left()))


func reset_time(secs):
	start_time(secs)


func _process(_delta):
	time.text = get_time()
