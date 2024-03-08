extends StaticBody2D

@onready var audio = $AudioStreamPlayer2D
@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func say_hi():
	print("hey")

func play_goal():
	anim.play("score")
	audio.play()
	await anim.animation_finished
