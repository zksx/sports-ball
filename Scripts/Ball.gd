extends CharacterBody2D

func _ready():
	set_velocity(Vector2(200, 200))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collison_info = move_and_collide(velocity * delta)
	if collison_info:
		var reflect = collison_info.get_remainder().bounce(collison_info.get_normal())
		velocity = velocity.bounce(collison_info.get_normal())
		move_and_collide(reflect)
