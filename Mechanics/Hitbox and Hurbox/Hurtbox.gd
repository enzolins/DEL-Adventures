extends Area2D

const HitEffect = preload("res://Effects/VFx/HitEffect.tscn")

var invencible = false setget setInvencible

signal invencibilityStarted
signal invencibilityEnded

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

func createHitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func setInvencible(value):
	invencible = value
	if invencible == true:
		emit_signal("invencibilityStarted")
	else:
		emit_signal("invencibilityEnded")


func _on_Timer_timeout():
	self.invencible = false


func startInvencibility(duration):
	self.invencible = true
	timer.start(duration)


func _on_Hurtbox_invencibilityStarted():
	#collisionShape.set_deferred("disabled", false)  
	set_deferred("monitoring", false) #---> Hard Mode


func _on_Hurtbox_invencibilityEnded():
	#collisionShape.disabled = false
	monitoring = true
