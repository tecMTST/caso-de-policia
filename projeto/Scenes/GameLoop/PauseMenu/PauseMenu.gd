class_name PauseMenu
extends Control

signal paused
signal resumed

@onready var audio_on: Sprite2D = $Audio/AudioOn
@onready var audio_off: Sprite2D = $Audio/AudioOff

func _ready() -> void:
	audio_on.visible = EstadoGlobal.Audio
	audio_off.visible = not EstadoGlobal.Audio
	
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


func _on_audio_button_pressed() -> void:
	if EstadoGlobal.Audio:
		EstadoGlobal.Audio = false
		AudioPlayer.MutarBackground()
		AudioPlayer.MutarForeground()
	else:
		EstadoGlobal.Audio = true
		AudioPlayer.TocarBackground()
		
	audio_on.visible = EstadoGlobal.Audio
	audio_off.visible = not EstadoGlobal.Audio
