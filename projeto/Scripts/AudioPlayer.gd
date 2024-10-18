extends Node

var audioStream : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var Inicializado : bool = false

func _ready() -> void:	
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	audioStream.stream = load("res://Assets/Audio/AudioSincronizado.tres")
	(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(0, -80)
	(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(1, -80)	
	add_child(audioStream)

func Iniciar():
	if not Inicializado:
		audioStream.play()
		Inicializado = true

func TocarBackground():
	if EstadoGlobal.Audio:
		(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(0, 0)
	
func TocarForeground():
	if EstadoGlobal.Audio:	
		(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(1, 0)
		
func MutarBackground():
	(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(0, -80)	
	
func MutarForeground():
	(audioStream.stream as AudioStreamSynchronized).set_sync_stream_volume(1, -80)
