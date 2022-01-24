extends "res://Mechanics/Hitbox and Hurbox/Hitbox.gd"

export(int) var SPEED = 150

onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.play("Idle")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	if animation_finished(animated_sprite, "Impact"):
		queue_free()
	

func destroy():
	animated_sprite.play("Impact")
	SPEED = 15


func _on_DemonEyeProjectile_area_entered(_area):
	destroy()


func _on_DemonEyeProjectile_body_entered(_body):
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func animation_finished(animation: AnimatedSprite, animation_name: String) -> bool: 
	var finished
	if animation.animation == animation_name and animation.frame == animation.frames.get_frame_count(animation_name) - 1:
		finished = true
	else:
		finished = false
	return finished
