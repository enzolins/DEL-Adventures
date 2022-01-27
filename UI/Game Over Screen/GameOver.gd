extends CanvasLayer

onready var game_over_screen = $Control
onready var game_over = $Control/Gameover
onready var tween = $Control/Tween

func _ready():
	game_over_screen.visible = false
	PlayerStats.connect("noHealth", self, "show_game_over_screen")

func show_game_over_screen():
	game_over_screen.visible = true
	tween.interpolate_property(game_over, "rect_scale", Vector2(0.1, 0.1), Vector2(2,2), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func set_game_over_screen_visibility(show: bool):
	game_over_screen.visible = show
