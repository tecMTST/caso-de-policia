extends Node2D

@onready var splash_scene = load("res://Scenes/Splash/Splash.tscn")

func _ready():
	SceneManager.change_to(splash_scene)
