extends Node

export(int) var max_health = 1 setget setMaxHealth
var health = max_health setget setHealth
export(int) var limitHealth = 7

export(int) var gold = 0 setget setGold

signal noHealth
signal healthChanged(value)
signal maxHealthChanged(value)
signal goldChanged(value)

func setHealth(value):
	health = value
	emit_signal("healthChanged", health)
	if health <= 0:
		emit_signal("noHealth")

func setMaxHealth(value):
	if max_health < limitHealth:
		max_health = value
		self.health = min(health, max_health)
		emit_signal("maxHealthChanged",max_health)
	else:
		pass
		
func setGold(value):
	gold += value
	emit_signal("goldChanged",gold)

func restartGold(value):
	gold = value
	emit_signal("goldChanged",gold)
	
func _ready():
	self.health = max_health
