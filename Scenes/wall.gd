extends StaticBody2D

@onready var audio_player = $"../AudioStreamPlayer2D"
@onready var anim_player = $AnimationPlayer
func _on_area_2d_body_entered(body):
	if body.is_in_group("disc"):
		audio_player.play()
		anim_player.play("hit")
