extends AudioStreamPlayer2D

func _ready():
	play()

func _on_CoinSFX_finished():
	queue_free()
