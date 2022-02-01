extends Area2D


export(String, FILE, "*.tscn, *.scn") var targetScene

func _physics_process(_delta):
	if monitoring == true:
		if get_overlapping_bodies().size() > 0 and String(targetScene) != "":
			nextLevel()

func nextLevel():
	var ERR = get_tree().change_scene(targetScene)
	var current_scene = get_parent()
	current_scene.queue_free()
	if ERR != OK:
		pass



func _on_LevelTransition_body_entered(_body):
	Global.fromLevel = get_parent().name
	print(Global.fromLevel)
	Global.walkDirection = _body.direction
