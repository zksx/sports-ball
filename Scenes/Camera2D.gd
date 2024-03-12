extends Camera2D

@export var randomStrength = 10
@export var shakeFade = 5

var shake_strength = 0

var rng = RandomNumberGenerator.new()


func _process(delta):
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0, shakeFade * delta)
		offset = ran_offset()
	
func ran_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength,shake_strength))
	

func shake():
	shake_strength = randomStrength
