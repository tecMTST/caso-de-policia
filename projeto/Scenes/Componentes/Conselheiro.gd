extends Control
class_name Conselheiro

enum Expressoes{
	Neutro,
	Sim,
	Nao	
}

signal Selecionar

@export var ImagemBalao : String = ""
@export var ImagemBalaoPressed : String = ""

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var textoSugestao: TimedLabel = $Balao/Texto
@onready var botao: TouchScreenButton = $Botao
@onready var nome: TextureRect = $Sprite/PivotNome/Nome
@onready var balao: TextureRect = $Balao
@onready var custo_1: TextureRect = $Balao/Custo/Custo1
@onready var custo_2: TextureRect = $Balao/Custo/Custo2
@onready var custo_3: TextureRect = $Balao/Custo/Custo3
@onready var custo_4: TextureRect = $Balao/Custo/Custo4
@onready var custo_5: TextureRect = $Balao/Custo/Custo5
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_nome: AnimationPlayer = $AnimationNome

var Ativo = false
@onready var spriteOriginaSize = sprite.scale
@onready var balaoOriginaSize = balao.scale

func _ready() -> void:
	balao.texture = load(ImagemBalao)
	botao.connect("pressed", _on_botao_pressed)
	animation_nome.play("rotacao")
	
func DefinirTexto(texto : String, custo: int):	
	animation_player.play("entrar")
	await get_tree().create_timer(0.5).timeout
	animation_player.play("idle")
	custo_1.visible = custo >= 1
	custo_2.visible = custo >= 5
	custo_3.visible = custo >= 10
	custo_4.visible = custo >= 20
	custo_5.visible = custo >= 40
	create_tween().tween_property(balao,"modulate:a", 1, 0.5)
	create_tween().tween_property(nome,"modulate:a", 1, 0.5)	
	textoSugestao.define_text(texto)
	textoSugestao.start()
	Ativo = true
	
func __limpar():
	Ativo = false
	textoSugestao.text = ""
	custo_1.visible = false
	custo_2.visible = false
	custo_3.visible = false
	custo_4.visible = false
	DefinirExpressao(Expressoes.Neutro)

func EsconderTexto():
	create_tween().tween_property(balao,"modulate:a", 0, 0.5)
	create_tween().tween_property(nome,"modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	__limpar()
	balao.texture = load(ImagemBalao)
	animation_player.play("sair")	

func DefinirExpressao(expressao: Expressoes):
	match expressao:
		Expressoes.Neutro:
			sprite.frame = 0
			create_tween().tween_property(sprite, "scale", spriteOriginaSize, 1)
			create_tween().tween_property(balao, "scale", balaoOriginaSize, 1)
		Expressoes.Sim:
			sprite.frame = 1
			balao.texture = load(ImagemBalaoPressed)
			create_tween().tween_property(sprite,"scale", Vector2(1.2, 1.2), 2)
			create_tween().tween_property(balao, "scale", Vector2(1.2, 1.2), 2)
		Expressoes.Nao:
			sprite.frame = 2
			create_tween().tween_property(sprite, "scale", Vector2(0.8, 0.8), 2)
			create_tween().tween_property(balao, "scale", Vector2(0.8, 0.8), 2)

func _on_botao_pressed() -> void:	
	if Ativo:
		Ativo = false
		DefinirExpressao(Expressoes.Sim)
		emit_signal("Selecionar")
