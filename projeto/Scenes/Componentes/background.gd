extends Control
class_name Background

signal Finalizado

@export var TempoTransicao : float = 2
@export var CorManha : Color = Color.from_string("e2ebbf", Color.ANTIQUE_WHITE)
@export var CorTarde : Color = Color.from_string("f3b562", Color.CORAL)

@onready var fundo: ColorRect = $Fundo
@onready var popularidade_down: GPUParticles2D = $PopularidadeDown
@onready var criminalidade: GPUParticles2D = $Criminalidade
@onready var custo: GPUParticles2D = $Custo
@onready var popularidade_up: GPUParticles2D = $PopularidadeUp

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
