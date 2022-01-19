extends Node2D

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

onready var camera = $MainCamera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	camera.current = true
	if Global.fromLevel != null:
		get_node("Player").set_position(get_node(Global.fromLevel + "Pos").position)
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)
		
func addRestart():
	var restart= Restart.instance()
	get_parent().add_child(restart)
