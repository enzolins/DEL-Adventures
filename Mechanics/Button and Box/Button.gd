extends Area2D

onready var animated_sprite = $AnimatedSprite

signal pressed
signal unpressed

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	animated_sprite.play("Unpressed")
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	if not body is Box:
		return
	animated_sprite.play("Pressed")
	emit_signal("pressed")
	
func _on_body_exited(body: PhysicsBody2D) -> void:
	if not body is Box:
		return
	animated_sprite.play("Unpressed")
	emit_signal("unpressed")
