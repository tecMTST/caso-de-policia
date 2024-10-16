extends Node2D


@onready var background: Background = $Base/Background
@onready var texto: Label = $Base/Texto

func _ready() -> void:
	DefinirResultado()

func DefinirResultado():
	
	if EstadoGlobal.Inclinacao < 0 and EstadoGlobal.Dinheiro <= 0:
		texto.text = EstadoGlobal.GameData.Configuracoes.TextoDerrotaDinheiro
		background.Emitir(false, true, false, false)
		return
	
	if EstadoGlobal.Criminalidade < EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaAlta or EstadoGlobal.Popularidade >= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaAlta:
		texto.text = EstadoGlobal.GameData.Configuracoes.TextoVitoriaAlta
		background.Emitir(true, false, false, false)
		return
		
	if EstadoGlobal.Criminalidade < EstadoGlobal.GameData.Configuracoes.CriminalidadeVitoriaModerada or EstadoGlobal.Popularidade >= EstadoGlobal.GameData.Configuracoes.PopularidadeVitoriaModerada:
		texto.text = EstadoGlobal.GameData.Configuracoes.TextoVitoriaModerada
		background.Emitir(true, false, false, false)
		return 
		
	if EstadoGlobal.Inclinacao > EstadoGlobal.GameData.Configuracoes.InclinacaoNeutro:	
		texto.text = EstadoGlobal.GameData.Configuracoes.TextoNeutro
		background.Emitir(false, false, false, false)
		return	
	
	texto.text = EstadoGlobal.GameData.Configuracoes.TextoDerrota
	background.Emitir(false, true, true, false)


func _on_iniciar_pressed() -> void:
	SceneManager.change_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
