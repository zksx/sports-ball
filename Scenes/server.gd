extends CharacterBody2D

@export var Ball : PackedScene

func serve(dir):
	var ball = spawn_ball()
	ball.position = Vector2(160,150)
	ball.launch(Vector2(dir, -50))


func spawn_ball():
	var ball = Ball.instantiate()
	owner.add_child(ball)
	return ball
