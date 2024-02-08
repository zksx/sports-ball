extends Node

var p1_score = 0
var p2_score = 0

var serve_left = -100
var serve_right = 100

@export var Ball : PackedScene
@onready var Server = $"../Server"

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$"../player2_score".text = str(p1_score)
	$"../player1_score".text = str(p2_score)
	pass

func _on_player_1_goal_body_entered(body):
	if body.is_in_group("disc"):

		body.queue_free()
		p2_score += 1
		Server.serve()

func _on_player_2_goal_body_entered(body):
	
	if body.is_in_group("disc"):

		body.queue_free()

		p1_score += 1
		print("goal on p2")
		Server.serve()

func victory():
	if( p1_score >= 10):
		print("p1 wins")
	elif (p2_score >= 10):
		print("p2 wins")

func ball_spawn():
	var ball = Ball.instantiate()
	add_child(ball)
	ball.serve()
