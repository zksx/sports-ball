extends CharacterBody2D

var time = 0
var is_curving = false
var y_weight : int
var throw_direction : int
var face_dir = 1
var curve_spd = 0

func _ready():
	pass

func _physics_process(delta):
	var collison_info = move_and_collide(velocity * delta)
	if collison_info:
		var reflect = collison_info.get_remainder().bounce(collison_info.get_normal())
		velocity = velocity.bounce(collison_info.get_normal())
		move_and_collide(reflect)
	if is_curving:
		curve(delta)

func serve():
	self.position = Vector2(160,90)
	set_velocity(Vector2(-100, -20))

func reset(x_dir):
	self.position = Vector2(320,180)
	set_velocity(Vector2(x_dir, 0))

func launch(vector):
	set_velocity(vector)

func start_curve(weight, curve_speed):
	y_weight = weight
	is_curving = true
	curve_spd = curve_speed
	
func curve(delta):
	var vel = self.get_velocity()
	
	vel.x = curve_spd
	
	if time <= 0.5:
		vel.y += y_weight
	else:
		vel.y += -y_weight

	self.set_velocity(Vector2(vel.x,vel.y))
	
	time += delta

	if time >= 0.75:
		time = 0
		y_weight = 0
		is_curving = false
