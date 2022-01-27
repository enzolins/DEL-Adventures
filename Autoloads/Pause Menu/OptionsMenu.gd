extends Control

func _on_GeralSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)


func _on_BGMSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),value)


func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),value)
