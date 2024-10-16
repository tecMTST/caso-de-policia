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

func _on_voltar_aojogo_pressed() -> void:
	resume()

func _on_voltar_ao_menu_pressed() -> void:
	resume()
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
