extends CharacterBody2D

@export var Ball : PackedScene
	
func serve(dir):
	var ball = Ball.instantiate()
	call_deferred("add_child", ball)
	ball.position = Vector2(0,-40)
	
	ball.set_velocity(Vector2(dir, -50))
