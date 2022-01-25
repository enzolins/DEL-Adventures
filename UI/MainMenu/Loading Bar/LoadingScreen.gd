extends Control

func _ready():
	goto_scene("res://Levels/Level1/Level1.tscn",self)


func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	var loading_bar = $ProgressBar
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF: #LOADING COMPLETE
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			CanPause.canPause()
			MusicController.playMusic()
			current_scene.queue_free()
			break
		if err == OK: #STILL LOADING
			var progress = float(loader.get_stage())/loader.get_stage_count()
			loading_bar.value = progress * 100
		yield(get_tree(),"idle_frame")
