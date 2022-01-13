extends Control

var menuTransitionTime = 0.5

var menuOriginPosition = Vector2.ZERO
var menuOriginSize = Vector2.ZERO
var currentMenu
var menuStack = []

onready var mainMenu = $MainMenu
onready var optionsMenu = $OptionsMenu
onready var controlsMenu = $Instructions
onready var select = $Select
onready var tween = $Tween

func _ready():
	menuOriginPosition = Vector2(0,0)
	menuOriginSize = get_viewport_rect().size
	currentMenu = mainMenu

func moveToNextMenu(nextMenuId: String):
	var nextMenu = getMenuFromMenuId(nextMenuId)
	tween.interpolate_property(currentMenu, "rect_global_position", currentMenu.rect_global_position, Vector2(-menuOriginSize.x,0), menuTransitionTime)
	tween.interpolate_property(nextMenu, "rect_global_position", nextMenu.rect_global_position, menuOriginPosition, menuTransitionTime)
	tween.start()
	menuStack.append(currentMenu)
	currentMenu = nextMenu

func moveToPreviousMenu():
	var previousMenu = menuStack.pop_back()
	if previousMenu != null:
		tween.interpolate_property(previousMenu, "rect_global_position", previousMenu.rect_global_position, menuOriginPosition, menuTransitionTime)
		tween.interpolate_property(currentMenu, "rect_global_position", currentMenu.rect_global_position, Vector2(menuOriginSize.x,0), menuTransitionTime)
		tween.start()
		currentMenu = previousMenu
	
func getMenuFromMenuId(menuId: String) -> Control:
	match menuId:
		"mainMenu":
			return mainMenu
		"optionsMenu":
			return optionsMenu
		"controlsMenu":
			return controlsMenu
		_:
			return mainMenu


func _on_Opcoes_pressed():
	moveToNextMenu("optionsMenu")
	select.play(0.0)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		moveToPreviousMenu()


func _on_Voltar_pressed():
	select.play(0.0)
	moveToPreviousMenu()


func _on_Sair_pressed():
	get_tree().quit()


func _on_Controles_pressed():
	moveToNextMenu("controlsMenu")
	select.play(0.0)


func _on_VoltarControls_pressed():
	select.play(0.0)
	moveToPreviousMenu()


func _on_FullScreen_pressed():
		OS.window_fullscreen = !OS.window_fullscreen
