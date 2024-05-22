extends StaticBody2D

@onready var audio = $AudioStreamPlayer2D
@onready var anim = $AnimationPlayer

func play_goal():
	anim.play("score")
	audio.play()
	await anim.animation_finished
