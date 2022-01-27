extends CanvasLayer

onready var bgm = $BGMMainMenu
onready var iniciar = $Control/Iniciar
onready var sair = $Control/Sair
onready var tween = $Control/Tween

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

###########################ANIMATIONS########################################
var max_size = Vector2(0.9,0.9)
var min_size = Vector2(0.7,0.7)

func _on_Iniciar_mouse_entered():
	tween.interpolate_property(iniciar, "rect_scale", iniciar.rect_scale, max_size, 0.15, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()


func _on_Iniciar_mouse_exited():
	tween.interpolate_property(iniciar, "rect_scale", iniciar.rect_scale, min_size, 0.15, Tween.TRANS_QUART, Tween.EASE_OUT)
	tween.start()


func _on_Sair_mouse_entered():
	tween.interpolate_property(sair, "rect_scale", sair.rect_scale, max_size, 0.15, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()


func _on_Sair_mouse_exited():
	tween.interpolate_property(sair, "rect_scale", sair.rect_scale, min_size, 0.15, Tween.TRANS_QUART, Tween.EASE_OUT)
	tween.start()
