extends CanvasLayer

signal levelChanged(levelName)

export(String) var levelName = "level"

onready var bgm = $BGMMainMenu


func _ready():
	MusicController.stopMusic()

func _on_Iniciar_pressed():
	CanPause.canPause()
	emit_signal("levelChanged", levelName)
	bgm.stop()
	MusicController.playMusic()

func _on_Sair_pressed():
	get_tree().quit()
