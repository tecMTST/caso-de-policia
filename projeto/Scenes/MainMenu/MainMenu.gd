extends Control

@onready var logo: TextureRect = $Logo
@onready var botoes: Control = $Botoes
@onready var animation_botao: AnimationPlayer = $AnimationBotao

var pronto : bool = false

func _ready() -> void:
	AudioPlayer.Iniciar()
	AudioPlayer.TocarBackground()
	logo.modulate.a = 0
	botoes.modulate.a = 0
	create_tween().tween_property(logo, "modulate:a", 1, 1)
	create_tween().tween_property(botoes, "modulate:a", 1, 1)
	await get_tree().create_timer(1).timeout
	animation_botao.play("botao")
	pronto = true

func _on_sobre_cta_pressed():
	SceneManager.change_to(load("res://Scenes/About/About.tscn"))

func _on_iniciar_pressed() -> void:
	if pronto:
		create_tween().tween_property(logo, "modulate:a", 0, 0.5)
		create_tween().tween_property(botoes, "modulate:a", 0, 0.5)
		await get_tree().create_timer(0.5).timeout
		SceneManager.change_to(load("res://Scenes/GameLoop/GameLoop.tscn"))	
