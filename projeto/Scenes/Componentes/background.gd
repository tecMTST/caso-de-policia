extends Control
class_name Background

signal Finalizado

@export var TempoTransicao : float = 2
@export var CorManha : Color = Color.from_string("e2ebbf", Color.ANTIQUE_WHITE)
@export var CorTarde : Color = Color.from_string("f3b562", Color.CORAL)
@onready var fundo: ColorRect = $Fundo
@onready var popularidade_down: CPUParticles2D = $PopularidadeDown
@onready var criminalidade: CPUParticles2D = $Criminalidade
@onready var custo: CPUParticles2D = $Custo
@onready var popularidade_up: CPUParticles2D = $PopularidadeUp
@onready var predios: TextureRect = $Predios

var coresInclinacao : Array[String] = ["5c4c52ff", "645c5e", "6c6c6d", "747e7b", "7b928c", "85a89e", "8dbfb3", "f15f61", "d35e5f", "b85b5c", "9e585a", "885458", "715055"]

func _ready() -> void:
	fundo.color = CorManha
	
func TransicaoTarde(popuUp : bool, popuDown : bool, crimeUp : bool, custoUp : bool):	
	Emitir(popuUp, popuDown, crimeUp, custoUp)	
	create_tween().tween_property(fundo, "color", CorTarde, TempoTransicao)
	await get_tree().create_timer(TempoTransicao).timeout
	Finalizar()
	
func Emitir(popuUp : bool, popuDown : bool, crimeUp : bool, custoUp : bool):
	popularidade_up.emitting = popuUp
	popularidade_down.emitting = popuDown
	criminalidade.emitting = crimeUp
	custo.emitting = custoUp	
	
func TransicaoManha():
	create_tween().tween_property(fundo, "color", CorManha, TempoTransicao)
	await get_tree().create_timer(TempoTransicao).timeout
	Finalizar()

func Finalizar():
	popularidade_down.emitting = false
	criminalidade.emitting = false
	popularidade_up.emitting = false
	custo.emitting = false
	emit_signal("Finalizado")

func PrediosInicial(inclinacao : int):
	if inclinacao > 6:
		inclinacao = 6
	if inclinacao < -6:
		inclinacao = -6
	predios.modulate = Color.from_string(coresInclinacao[inclinacao], coresInclinacao[0])
	
func DefinirPredios(inclinacao : int):
	if inclinacao > 6:
		inclinacao = 6
	if inclinacao < -6:
		inclinacao = -6
	create_tween().tween_property(predios, "modulate", Color.from_string(coresInclinacao[inclinacao], coresInclinacao[0]), 0.5)
