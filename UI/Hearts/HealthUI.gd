extends Control

var hearts = 4 setget setHearts
var max_hearts = 4 setget setMaxHearts

onready var heartFull = $HeartFull
onready var heartEmpty = $HeartEmpty

func setHearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartFull != null:
		heartFull.rect_size.x = hearts * 15
	
func setMaxHearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartEmpty != null:
		heartEmpty.rect_size.x = max_hearts * 15

func noHearts():
	heartFull.visible = false

	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("healthChanged", self, "setHearts")
	PlayerStats.connect("maxHealthChanged", self, "setMaxHearts")
	PlayerStats.connect("noHealth",self,"noHearts")
