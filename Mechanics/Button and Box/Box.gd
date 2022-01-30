extends RigidBody2D
class_name Box



func _integrate_forces(_state):
	rotation_degrees = 0
	angular_velocity = 0
	

func _on_PlayerSlowDown_area_entered(_area):
	sleeping = false


func _on_PlayerSlowDown_area_exited(_area):
	sleeping = true
