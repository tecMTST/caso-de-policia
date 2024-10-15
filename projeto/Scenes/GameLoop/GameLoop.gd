extends Node2D

enum Estados {
	DefinirSugestao,
	MostrarNoticia,
	MudarTarde,
	EsperarEscolha,
	EsperarDia,
	EsperarNoticia
}
enum Turnos {
	Manha,
	Tarde
}

var estado : Estados = Estados.DefinirSugestao
var gameData : GameData
var criminalidade : float
var popularidade : float
var dia : int = 1
var sugestoesUsadas : Array[int] = []
var custoAtual : float  = 0
var dinheiro : float  = 0
var sugestaoA : Suggestion
var sugestaoB : Suggestion
var noticiaAtual : News
var ultimaSugestaoId : int  = 0
var tempoEspera : float = 0
var timerEspera : float = 0
var popuUp : bool
var popuDown : bool
var crimeUp : bool
var custoUp : bool
var turno : Turnos = Turnos.Manha

@onready var background: Background = $Base/Background
@onready var douces: Conselheiro = $Base/Douces
@onready var lourdes: Conselheiro = $Base/Lourdes
@onready var pause_menu: PauseMenu = $PauseMenuOverlay/PauseMenu
@onready var texto_noticia: Label = $Base/Noticias/TextureNoticia/TextoNoticia
@onready var texture_noticia: TextureRect = $Base/Noticias/TextureNoticia
@onready var texto_dia: Label = $Base/Topo/BoxTopo/TextoDia
@onready var texto_turno: Label = $Base/Topo/BoxTopo/TextoTurno
@onready var progress_crime: ProgressBar = $Base/Rodape/BoxRodape/BoxCrime/ProgressCrime
@onready var progress_dinheiro: ProgressBar = $Base/Rodape/BoxRodape/BoxDinheiro/ProgressDinheiro
@onready var progress_popularidade: ProgressBar = $Base/Rodape/BoxRodape/BoxCrime3/ProgressPopularidade

func _ready() -> void:
	gameData = GameDataLoader.LoadGameData()
	criminalidade = gameData.InitialStatus.Criminality
	popularidade = gameData.InitialStatus.Popularity
	dinheiro = gameData.InitialStatus.Cash
	background.TempoTransicao = gameData.InitialStatus.TransitionTime
	tempoEspera = gameData.InitialStatus.TransitionTime
	timerEspera = tempoEspera	

func _process(delta: float) -> void:
	match estado:
		Estados.DefinirSugestao:
			ProcessarDefinirSugestao()
		Estados.EsperarEscolha:
			pass
		Estados.MudarTarde:
			ProcessarMudarTarde()
		Estados.EsperarDia:
			pass
		Estados.MostrarNoticia:
			ProcessarMostrarNoticia()
		Estados.EsperarNoticia:
			pass
	DefinirJogo()

func ProcessarMudarTarde():	
	estado = Estados.EsperarDia
	turno = Turnos.Tarde
	douces.EsconderTexto()
	lourdes.EsconderTexto()
	background.TransicaoTarde(popuUp, popuDown, crimeUp, custoUp)

func ProcessarDefinirSugestao():
	var disponiveisA = gameData.Suggetions.filter(func (i : Suggestion) : return i.Candidate == 'Douces' and not sugestoesUsadas.has(i.Id))
	var disponiveisB = gameData.Suggetions.filter(func (i : Suggestion) : return i.Candidate == 'Lurdes' and not sugestoesUsadas.has(i.Id))
	if len(disponiveisA) <= 0 or len(disponiveisB) <= 0:
		pass #Game Over -> result
	sugestaoA = disponiveisA.pick_random() as Suggestion
	sugestaoB = disponiveisB.pick_random() as Suggestion
	sugestoesUsadas.append(sugestaoA.Id)
	sugestoesUsadas.append(sugestaoB.Id)	
	douces.DefinirTexto(sugestaoA.Text, sugestaoA.Cost)
	lourdes.DefinirTexto(sugestaoB.Text, sugestaoB.Cost)
	estado = Estados.EsperarEscolha
	
func ProcessarMostrarNoticia():
	estado = Estados.EsperarNoticia
	var possivel = gameData.News.filter(func (i: News) : return i.SuggestionId == ultimaSugestaoId)
	noticiaAtual = possivel.pick_random() as News
	texto_noticia.text = noticiaAtual.Text
	create_tween().tween_property(texture_noticia, "modulate:a", 1, 0.5)
	await get_tree().create_timer(tempoEspera).timeout
	
func FecharNoticia():
	create_tween().tween_property(texture_noticia, "modulate:a", 0, 0.5)
	background.TransicaoManha()
	await get_tree().create_timer(tempoEspera).timeout
	finalizarTurno()
	
func finalizarTurno():
	timerEspera = tempoEspera
	dia += 1
	dinheiro -= custoAtual		
	estado = Estados.DefinirSugestao
	turno = Turnos.Manha

func SelecionarSugestao(sugestao : Suggestion):
	ultimaSugestaoId  = sugestao.Id
	custoAtual += sugestao.Cost
	popuUp = sugestao.Popularity > 0
	popuDown = sugestao.Popularity < 0
	crimeUp = sugestao.Criminality > 0
	custoUp = sugestao.Cost > 3
	await get_tree().create_timer(tempoEspera).timeout
	estado = Estados.MudarTarde	
	
func DefinirJogo():
	texto_dia.text = "Dia " + str(dia)
	if turno == Turnos.Manha:
		texto_turno.text = "Manhã"
	else:
		texto_turno.text = "Tarde"
	
	progress_crime.value = criminalidade
	progress_dinheiro.value = dinheiro
	progress_popularidade.value = popularidade
	
	if dinheiro <= 0:
		# Gameover Baknrupt
		SceneManager.change_to(load("res://Scenes/Defeat/Defeat.tscn"))
		
	if dia >= gameData.InitialStatus.DaysLimit:
		SceneManager.change_to(load("res://Scenes/Victory/Victory.tscn"))
		

func _on_background_finalizado() -> void:	
	if estado == Estados.EsperarDia:
		estado = Estados.MostrarNoticia

func _on_douces_selecionar() -> void:
	if estado == Estados.EsperarEscolha:
		lourdes.DefinirExpressao(Conselheiro.Expressoes.Nao)
		SelecionarSugestao(sugestaoA)
	
func _on_lourdes_selecionar() -> void:
	if estado == Estados.EsperarEscolha:
		douces.DefinirExpressao(Conselheiro.Expressoes.Nao)
		SelecionarSugestao(sugestaoB)

func _on_pause_pressed() -> void:
	pause_menu.visible = true
	get_tree().paused = true

func _on_pause_menu_resumed() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _on_fechar_noticia_pressed() -> void:
	if estado == Estados.EsperarNoticia:
		FecharNoticia()
