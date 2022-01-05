extends "res://Mechanics/Hitbox and Hurbox/Hitbox.gd"

export(int) var SPEED = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	

func destroy():
	queue_free()


func _on_Arrow_area_entered(area):
	destroy()


func _on_Arrow_body_entered(body):
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()
