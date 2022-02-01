extends CanvasLayer

const Restart = preload("res://Autoloads/Restarting/Restart.tscn")

onready var boss_defeated_screen = $Control
onready var boss_killed = $Control/BossKilled
onready var boss_killed_sfx = $Control/BossDefeatedSFX
onready var tween = $Control/Tween
onready var animation_player = $AnimationPlayer

func _ready():
	boss_defeated_screen.visible = false
	BossStatsPlaceHolder.connect("boss_dead", self, "show_boss_defeated_screen")
	BossStatsPlaceHolder.connect("boss_dead", self, "add_restart")
	
func show_boss_defeated_screen():
	MusicController.stopMusic()
	boss_defeated_screen.visible = true
	CanPause.cannotPause()
	tween.interpolate_property(boss_killed, "rect_scale", Vector2(0.1, 0.1), Vector2(2,2), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	animation_player.play("Pulse")

func add_restart():
	var restart= Restart.instance()
	add_child(restart)


func _on_Tween_tween_all_completed():
	boss_killed_sfx.play()

func set_boss_defeated_screen_visibility(show: bool):
	boss_defeated_screen.visible = show
