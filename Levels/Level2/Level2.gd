extends Node2D

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

onready var camera = $MainCamera
onready var bottomRight = $MainCamera/Limits/BottomRight

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	camera.current = true
	bottomRight.position = Vector2(424,112)
	if Global.fromLevel != null:
		get_node("Player").set_position(get_node(Global.fromLevel + "Pos").position)
		if Global.fromLevel == "Level3":
			get_node("Player").flipPlayer()
			bottomRight.position = Vector2(1072,384)
			camera.changeLimits()
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)


func addRestart():
	var restart= Restart.instance()
	add_child(restart)


func _on_CameraLimitsSwitcher_body_entered(body):
	bottomRight.position = Vector2(1072,384)
	camera.changeLimits()
