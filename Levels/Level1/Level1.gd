extends Node2D

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

signal levelChanged(levelName)

export(String) var levelName = "level"

onready var camera = $MainCamera

func addRestart():
	var restart= Restart.instance()
	get_parent().add_child(restart)

func _ready():
	camera.current = true
	if Global.fromLevel != null:
		get_node("Player").set_position(get_node(Global.fromLevel + "Pos").position)
		get_node("Player").flipPlayer()
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)
	
