extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().change_scene("res://Levels/Testing/TestingLevel.tscn")
		PlayerStats.setHealth(4)
		PlayerStats.setMaxHealth(4)
		PlayerStats.restartGold(0)
		Global.fromLevel = null
		GameOver.set_game_over_screen_visibility(false)
		CanPause.canPause()
