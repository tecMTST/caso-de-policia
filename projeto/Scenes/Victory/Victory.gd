extends Node2D


@onready var background: Background = $Base/Background
@onready var texto: Label = $Base/Texto
@onready var douces: Control = $Base/Escolhas/Douces
@onready var animation_douces: AnimationPlayer = $Base/Escolhas/Douces/AnimationDouces
@onready var lourdes: Control = $Base/Escolhas/Lourdes
@onready var animation_lourdes: AnimationPlayer = $Base/Escolhas/Lourdes/AnimationLourdes

func _ready() -> void:
	AudioPlayer.Iniciar()
	AudioPlayer.TocarBackground()
	AudioPlayer.MutarForeground()
	DefinirResultado()

func DefinirResultado():
	
	background.PrediosInicial(EstadoGlobal.Inclinacao)
	
	if EstadoGlobal.Inclinacao >= 0: #Inclinação Douces:
		animation_douces.play("idle")
		create_tween().tween_property(douces, "modulate:a", 1, 0.3)
		if EstadoGlobal.Dinheiro <= 0:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoNeutro
			background.Emitir(false, false, false, false)
		elif EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaAlta or EstadoGlobal.Popularidade >= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaAlta:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoVitoriaAlta
			background.Emitir(true, false, false, false)
		elif EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaModerada or EstadoGlobal.Popularidade >= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaModerada:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoVitoriaModerada
			background.Emitir(true, false, false, false)
		elif EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.CriminalidadeInicial:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoVitoriaModerada
			background.Emitir(true, false, false, false)
		else:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoNeutro
			background.Emitir(false, false, false, false)
			
	else: #Inclinação Lourdes:
		animation_lourdes.play("idle")
		create_tween().tween_property(lourdes, "modulate:a", 1, 0.3)
		if EstadoGlobal.Dinheiro <= 0:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoDerrotaDinheiro
		elif EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaModerada or EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaAlta:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoNeutro
		elif EstadoGlobal.Popularidade <= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaModerada or EstadoGlobal.Criminalidade <= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaAlta:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoNeutro	
		else:
			texto.text = EstadoGlobal.GameData.Configuracoes.TextoDerrota
		background.Emitir(false, true, true, false)



func _on_iniciar_pressed() -> void:
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
