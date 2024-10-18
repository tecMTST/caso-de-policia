extends Node

var background : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var foreground : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var Inicializado : bool = false

func _ready() -> void:	
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	background.stream = load("res://Assets/Audio/Caso de Polícia - Abertura.mp3")
	foreground.stream = load("res://Assets/Audio/Caso de Polícia - Gameplay.mp3")
	background.volume_db = -80
	foreground.volume_db = -80
	add_child(background)
	add_child(foreground)

func Iniciar():
	if not Inicializado:
		background.play()
		foreground.play()
		Inicializado = true

func TocarBackground():
	if EstadoGlobal.Audio:
		create_tween().tween_property(background, "volume_db", 0, 0.2)
	
func TocarForeground():
	if EstadoGlobal.Audio:	
		create_tween().tween_property(foreground, "volume_db", 0, 0.2)
		
func MutarBackground():
	create_tween().tween_property(background, "volume_db", -80, 0.2)
	
func MutarForeground():
	create_tween().tween_property(foreground, "volume_db", -80, 0.2)
