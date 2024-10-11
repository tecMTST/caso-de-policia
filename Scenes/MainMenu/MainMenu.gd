extends Control

func _on_iniciar_jogo_cta_pressed():
	SceneManager.change_to(load("res://Scenes/GameLoop/GameLoop.tscn"))

func _on_sobre_cta_pressed():
	SceneManager.change_to(load("res://Scenes/About/About.tscn"))
