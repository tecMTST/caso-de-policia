class_name PauseMenu
extends Control

signal paused
signal resumed

func pause():
	emit_signal("paused")
	get_tree().paused = true

func resume():
	get_tree().paused = false
	emit_signal("resumed")

func _on_resume_cta_pressed():
	resume()

func _on_main_menu_cta_pressed():
	resume()
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
