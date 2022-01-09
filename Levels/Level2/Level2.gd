extends Node2D

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

#onready var camera = $Camera2D

func _ready():
	#camera.current = true
	if Global.fromLevel != null:
		get_node("Player").set_position(get_node(Global.fromLevel + "Pos").position)
		#get_node("Player").flipPlayer()
	PlayerStats.connect("noHealth", self, "addRestart")
	PlayerStats.restartGold(PlayerStats.gold)
		
func addRestart():
	var restart= Restart.instance()
	get_parent().add_child(restart)
