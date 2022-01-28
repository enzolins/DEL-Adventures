extends AudioStreamPlayer

func _ready():
	play()

func _on_HealSFX_finished():
	queue_free()
