extends StaticBody2D

@onready var audio_player = $"../AudioStreamPlayer2D"

func _on_area_2d_body_entered(body):
	if body.is_in_group("disc"):
		audio_player.play()
