extends Node

var p1_score = 0
var p2_score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$player1_score.text = str(p1_score)
	$player2_score.text = str(p2_score)
	victory()


func _on_player_1_goal_body_entered(body):
	if body.name == "Ball":
		$Ball.position = Vector2(300,300)
		p2_score += 1;

func _on_player_2_goal_body_entered(body):
	if body.name == "Ball":
		$Ball.position = Vector2(300,300)
		p1_score += 1;
		
func victory():
	if( p1_score >= 10):
		print("p1 wins")
	elif (p2_score >= 10):
		print("p2 wins")
