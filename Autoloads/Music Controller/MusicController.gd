extends Node

onready var music = $Music

var bgm = load("res://Musics/Retro Forest.mp3")
var game_over_sfx = load("res://Effects/SFx/Game Over 2.wav")

func _ready():
	PlayerStats.connect("noHealth", self, "game_over")

func playMusic():
	music.stream = bgm
	music.play()
	
func stopMusic():
	music.stop()

func game_over():
	music.stream = game_over_sfx
	music.play()
