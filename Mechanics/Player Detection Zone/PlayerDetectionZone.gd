extends Area2D

var player = null

func _on_PlayerDetectionZone_body_entered(body):
	player = body


func _on_PlayerDetectionZone_body_exited(_body):
	player = null

func canSeePlayer():
	return player != null

func playerHead():
	return player.get_node("Head").global_position
