extends Node

var max_health
var health setget print_life
var previous_health

signal boss_dead

func print_life(value):
	health = value
	if health <= 0:
		emit_signal("boss_dead")
