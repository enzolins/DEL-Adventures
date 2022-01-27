extends Control

onready var tween = $Tween
onready var continuar = $Continuar
onready var opcoes = $Opcoes
onready var controles = $Controles
onready var sair = $Sair

var max_size : Vector2 = Vector2(0.8,0.8)
var min_size : Vector2 = Vector2(0.7,0.7)

func increase_size(button : Button):
	tween.interpolate_property(button, "rect_scale", button.rect_scale, max_size, 0.15, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()
	
func decrease_size(button : Button):
	tween.interpolate_property(button, "rect_scale", button.rect_scale, min_size, 0.15, Tween.TRANS_QUART, Tween.EASE_OUT)
	tween.start()


func _on_Continuar_mouse_entered():
	increase_size(continuar)


func _on_Continuar_mouse_exited():
	decrease_size(continuar)


func _on_Opcoes_mouse_entered():
	increase_size(opcoes)


func _on_Opcoes_mouse_exited():
	decrease_size(opcoes)


func _on_Controles_mouse_entered():
	increase_size(controles)


func _on_Controles_mouse_exited():
	decrease_size(controles)


func _on_Sair_mouse_entered():
	increase_size(sair)


func _on_Sair_mouse_exited():
	decrease_size(sair)
