extends CharacterBody2D

var time = 0
var is_curving = false
var y_weight : int

func _ready():
	pass

func _physics_process(delta):
	var collison_info = move_and_collide(velocity * delta)
	if collison_info:
		var reflect = collison_info.get_remainder().bounce(collison_info.get_normal())
		velocity = velocity.bounce(collison_info.get_normal())
		move_and_collide(reflect)
	if is_curving:
		var vel = self.get_velocity()
		vel.x += y_weight
		if time <= 0.5:
			vel.y += y_weight
		else:
			vel.y += -y_weight
		self.set_velocity(Vector2(vel.x,vel.y))
	
		time += delta
		if time >= 1:
			time = 0
			y_weight = 0
			is_curving = false
			print("Done")

func serve():
	self.position = Vector2(340,250)
	set_velocity(Vector2(-100, -20))

func reset():
	self.position = Vector2(320,180)
	set_velocity(Vector2(-100, 20))
	
func launch(vector):
	set_velocity(vector)
	
func curve(curve_weight):
	y_weight = curve_weight
	is_curving = true
