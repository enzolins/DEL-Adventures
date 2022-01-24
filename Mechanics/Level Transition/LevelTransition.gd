extends Area2D


export(String, FILE, "*.tscn, *.scn") var targetScene

func _physics_process(_delta):
	if monitoring == true:
		if get_overlapping_bodies().size() > 0 and targetScene != null:
			nextLevel()

func nextLevel():
	var ERR = get_tree().change_scene(targetScene)

	if ERR != OK:
		pass



func _on_LevelTransition_body_entered(_body):
	Global.fromLevel = get_parent().name
	Global.walkDirection = _body.direction
