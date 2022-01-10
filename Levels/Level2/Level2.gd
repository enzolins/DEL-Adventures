extends Node2D

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

onready var camera = $MainCamera
onready var bottomRight = $MainCamera/Limits/BottomRight

func _ready():
	camera.current = true
	if Global.fromLevel != null:
		get_node("Player").set_position(get_node(Global.fromLevel + "Pos").position)
		#get_node("Player").flipPlayer()
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)
	bottomRight.position = Vector2(424,112)
		
func addRestart():
	var restart= Restart.instance()
	get_parent().add_child(restart)


func _on_CameraLimitsSwitcher_body_entered(body):
	bottomRight.position = Vector2(1072,384)
	camera.changeLimits()
