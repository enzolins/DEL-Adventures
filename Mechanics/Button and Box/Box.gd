extends RigidBody2D
class_name Box



func _integrate_forces(state):
	rotation_degrees = 0
	

func _on_PlayerSlowDown_area_entered(area):
	sleeping = false


func _on_PlayerSlowDown_area_exited(area):
	sleeping = true
