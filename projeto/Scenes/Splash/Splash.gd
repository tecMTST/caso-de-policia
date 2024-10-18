extends Control

@onready var sfx_splash: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var logo_nt: TextureRect = $LogoNT
@onready var black_mask: ColorRect = $BlackMask

func _ready():
	sfx_splash.play()
	await get_tree().create_timer(0.5).timeout
	logo_nt.material.set_shader_parameter("enabled", 1)
	await get_tree().create_timer(0.7).timeout
	logo_nt.material.set_shader_parameter("enabled", 0)
	await get_tree().create_timer(0.5).timeout
	create_tween().tween_property(black_mask, "modulate:a", 1, 1)
	await get_tree().create_timer(1).timeout
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
