extends Node

onready var music = $Music

var bgm = load("res://Musics/Retro Forest.mp3")

func playMusic():
	music.stream = bgm
	music.play()
	
func stopMusic():
	music.stop()
