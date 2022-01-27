extends CanvasLayer

onready var menuOptions = $MenuOptions
onready var pause = $Pause
onready var unpause = $Unpause

var isPaused = false

func _ready():
	menuOptions.visible = false

func _input(event):
	if CanPause.getCanPause() == true:
		if event.is_action_pressed("ui_cancel"):
			pauseGame()
			if isPaused == false:
				isPaused = true
				pause.play(0.0)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				isPaused = false
				unpause.play(0.0)
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		pass


func _on_Continuar_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	menuOptions.visible = false
	unpause.play(0.0)

func pauseGame():
	menuOptions.visible = !menuOptions.visible
	get_tree().paused = !get_tree().paused
