extends Control


onready var progress_bar = $ProgressBar
onready var tween = $Tween
onready var timer = $RemoverBar

var max_health
var current_health 
var previous_health
var current_value
var previous_value
var count: int = 0

var finished: bool = false
var is_dead: bool = false

var initial_color = Color(1,1,1,1)
var final_color = Color(1,1,1,0)

func _ready():
	tween.interpolate_property(progress_bar, "value", 0, 100, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate", final_color, initial_color, 0.75, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()
	max_health = BossStatsPlaceHolder.max_health
	current_health = BossStatsPlaceHolder.health
	previous_health = BossStatsPlaceHolder.previous_health

func _process(_delta):
	current_health = BossStatsPlaceHolder.health
	previous_health = BossStatsPlaceHolder.previous_health
	current_value = (current_health * 100)/max_health
	previous_value = (previous_health * 100)/max_health
	update_bar()

func update_bar():
	if finished:
		progress_bar.value = current_value
	if current_health <= 0 and count <= 0:
		timer.start()
		count += 1
		is_dead = true

func _on_Tween_tween_all_completed():
	finished = true
	if is_dead:
		get_parent().queue_free()


func _on_RemoverBar_timeout():
	tween.interpolate_property(self, "modulate", initial_color, final_color, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
