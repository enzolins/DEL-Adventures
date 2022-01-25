extends CanvasLayer

onready var bgm = $BGMMainMenu

func _ready():
	MusicController.stopMusic()

func _on_Iniciar_pressed():
	bgm.stop()
	goto_scene("res://UI/MainMenu/Loading Bar/LoadingScreen.tscn",self)

func _on_Sair_pressed():
	get_tree().quit()

func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			current_scene.queue_free()
			break
		if err == OK:
			var progress = float(loader.get_stage())/loader.get_stage_count()
