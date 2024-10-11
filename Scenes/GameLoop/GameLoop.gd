extends Node2D

@onready var pause_menu: PauseMenu = $PauseMenuOverlay/PauseMenu

func _on_vitoria_cta_pressed():
	SceneManager.change_to(load("res://Scenes/Victory/Victory.tscn"))

func _on_derrota_cta_pressed():
	SceneManager.change_to(load("res://Scenes/Defeat/Defeat.tscn"))

func _on_pause_cta_pressed():
	pause_menu.pause()

func _on_pause_menu_paused():
	pause_menu.show()

func _on_pause_menu_resumed():
	pause_menu.hide()
