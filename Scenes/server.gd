extends CharacterBody2D

@export var Ball : PackedScene
	
func serve():
	var ball = Ball.instantiate()
	call_deferred("add_child", ball)

	ball.position = Vector2(0,0)
	ball.set_velocity(Vector2(-100, -30))
	print('Served')
