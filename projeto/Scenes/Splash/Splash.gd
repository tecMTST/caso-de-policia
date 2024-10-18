extends Control

@onready var sfx_splash: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var logo_nt: TextureRect = $LogoNT

func _ready():
	sfx_splash.play()
	await get_tree().create_timer(0.5).timeout
	logo_nt.material.set_shader_parameter("enabled", 1)
	await get_tree().create_timer(0.5).timeout
	logo_nt.material.set_shader_parameter("enabled", 0)
	await sfx_splash.finished
	# 0,5 segundo depois do audio de splash, vai pro menu principal
	await get_tree().create_timer(0.5).timeout
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
