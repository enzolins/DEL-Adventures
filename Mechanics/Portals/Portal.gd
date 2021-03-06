extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var level_transition = $LevelTransition

func _ready():
	animated_sprite.visible = false
	level_transition.set_deferred("monitoring", false)
	
func open_portal():
	animated_sprite.visible = true
	animated_sprite.play("Open")

func idle_portal():
	animated_sprite.play("Idle")
	level_transition.set_deferred("monitoring", true)

func close_portal():
	animated_sprite.play("Close")
	level_transition.set_deferred("monitoring", false)

func _on_Button_pressed():
	open_portal()

func _on_Button_unpressed():
	close_portal()
	
func _physics_process(_delta):
		if animation_finished(animated_sprite, "Open"):
			idle_portal()
		if animation_finished(animated_sprite, "Close"):
			animated_sprite.visible = false

func animation_finished(animation: AnimatedSprite, animation_name: String) -> bool: 
	var finished
	if animation.animation == animation_name and animation.frame == animation.frames.get_frame_count(animation_name) - 1:
		finished = true
	else:
		finished = false
	return finished
