extends Control
class_name Conselheiro

enum Expressoes{
	Neutro,
	Sim,
	Nao	
}

signal Selecionar

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var textoSugestao: TimedLabel = $Balao/Texto
@onready var botao: TouchScreenButton = $Botao
@onready var balao: TextureRect = $Balao
@onready var custo_1: TextureRect = $Balao/Custo/Custo1
@onready var custo_2: TextureRect = $Balao/Custo/Custo2
@onready var custo_3: TextureRect = $Balao/Custo/Custo3
@onready var custo_4: TextureRect = $Balao/Custo/Custo4
@onready var custo_5: TextureRect = $Balao/Custo/Custo5
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	botao.connect("pressed", _on_botao_pressed)
	
func DefinirTexto(texto : String, custo: int):	
	animation_player.play("entrar")
	await get_tree().create_timer(0.5).timeout
	custo_1.visible = custo >= 1
	custo_2.visible = custo >= 3
	custo_3.visible = custo >= 5
	custo_4.visible = custo >= 8
	custo_5.visible = custo >= 10
	create_tween().tween_property(balao,"modulate:a", 1, 0.5)
	textoSugestao.define_text(texto)
	textoSugestao.start()	
	
func __limpar():
	textoSugestao.text = ""
	custo_1.visible = false
	custo_2.visible = false
	custo_3.visible = false
	custo_4.visible = false
	DefinirExpressao(Expressoes.Neutro)

func EsconderTexto():
	var tween = create_tween()
	tween.tween_callback(__limpar)
	tween.tween_property(balao,"modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	animation_player.play("sair")

func DefinirExpressao(expressao: Expressoes):
	match expressao:
		Expressoes.Neutro:
			sprite.frame = 0
		Expressoes.Sim:
			sprite.frame = 1
		Expressoes.Nao:
			sprite.frame = 2

func _on_botao_pressed() -> void:
	DefinirExpressao(Expressoes.Sim)
	emit_signal("Selecionar")
