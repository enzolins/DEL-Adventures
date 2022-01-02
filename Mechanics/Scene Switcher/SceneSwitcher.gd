extends Node

onready var currentLevel = $MainMenu

func _ready():
	currentLevel.connect("levelChanged",self,"handleLevelChange")
	
func handleLevelChange(currentLevelName: String):
	var nextLevel
	var nextLevelName: String
	
	match currentLevelName:
		"MainMenu":
			nextLevelName = "Level1"
		_:
			return
	
	nextLevel = load("res://Levels/" + nextLevelName + "/" + nextLevelName + ".tscn").instance()
	add_child(nextLevel)
	nextLevel.connect("levelChanged",self,"handleLevelChange")
	currentLevel.queue_free()
	currentLevel = nextLevel
