extends CharacterBody2D

func _ready():
	pass

func _physics_process(delta):
	var collison_info = move_and_collide(velocity * delta)
	if collison_info:
		var reflect = collison_info.get_remainder().bounce(collison_info.get_normal())
		velocity = velocity.bounce(collison_info.get_normal())
		move_and_collide(reflect)

func serve():
	self.position = Vector2(320,180)
	set_velocity(Vector2(-100, -20))
	

func reset():
	self.position = Vector2(320,180)
	set_velocity(Vector2(-100, 20))
	
func launch(vector):
	set_velocity(vector)
