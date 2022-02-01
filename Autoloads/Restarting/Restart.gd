extends Node

func _process(_delta):
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().change_scene("res://Levels/Level1/Level1.tscn")
		PlayerStats.setHealth(4)
		PlayerStats.setMaxHealth(4)
		PlayerStats.restartGold(0)
		MusicController.playMusic()
		Global.fromLevel = null
		GameOver.set_game_over_screen_visibility(false)
		BossDefeated.set_boss_defeated_screen_visibility(false)
		CanPause.canPause()
		get_parent().queue_free()
