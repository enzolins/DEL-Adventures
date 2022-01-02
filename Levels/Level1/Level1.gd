extends Node2D

const Restart = preload("res://Mechanics/Restarting/Restart.tscn")

signal levelChanged(levelName)

export(String) var levelName = "level"

func addRestart():
	var restart= Restart.instance()
	get_parent().add_child(restart)

func _ready():
#	if Global.fromLevel != null:
#		get_node("YSort/Player").set_position(get_node(Global.fromLevel + "Pos").position)
#		get_node("YSort/Player").setPlayerIdlePosition(Global.walkDirection)
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)
	
