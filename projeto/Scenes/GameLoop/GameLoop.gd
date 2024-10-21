extends Node2D

enum Estados {
	AnimarDia,
	DefinirSugestao,
	MostrarNoticia,
	MudarTarde,
	EsperarAbertura,
	EsperarAnimarDia,
	EsperarEscolha,
	EsperarDia,
	EsperarNoticia,
	EsperarFecharNoticia,
	FimDeTurno,
	FimDeJogo
}
enum Turnos {
	Manha,
	Tarde
}

const textoPergunta : String = "Quais são suas propostas,\r\nconselheiros?"
const textoTransicao : String = "O que rolou…"
const tempoMovimento: float = 0.2

var estado : Estados = Estados.EsperarAbertura
var gameData : GameData
var criminalidade : float
var popularidade : float
var dia : int = 1
var sugestoesUsadas : Array[int] = []
var dinheiro : float  = 0
var sugestaoA : Sugestao
var sugestaoB : Sugestao
var noticiaAtual : Noticia
var ultimaSugestaoId : int  = 0
var tempoEspera : float = 0
var timerEspera : float = 0
var popuUp : bool
var popuDown : bool
var crimeUp : bool
var custoUp : bool
var turno : Turnos = Turnos.Manha
var timerAbertura : float = 10
var inclinacao : int = 0
var titulosNoticia : Array[String] = ["res://Assets/Imagens/provincia.png", "res://Assets/Imagens/pagina.png"]

@onready var background: Background = $Base/Background
@onready var douces: Conselheiro = $Base/Douces
@onready var lourdes: Conselheiro = $Base/Lourdes
@onready var pause_menu: PauseMenu = $PauseMenuOverlay/PauseMenu
@onready var texto_noticia: Label = $Base/Noticias/TextureNoticia/TextoNoticia
@onready var texture_noticia: TextureRect = $Base/Noticias/TextureNoticia
@onready var titulo_noticia: TextureRect = $Base/Noticias/TextureNoticia/TituloNoticia
@onready var texto_dia: Label = $Base/Topo/BoxTopo/TextoDia
@onready var texto_turno: Label = $Base/Topo/BoxTopo/TextoTurno
@onready var progress_crime: ProgressBar = $Base/Rodape/BoxRodape/BoxCrime/ProgressCrime
@onready var progress_dinheiro: ProgressBar = $Base/Rodape/BoxRodape/BoxDinheiro/ProgressDinheiro
@onready var progress_popularidade: ProgressBar = $Base/Rodape/BoxRodape/BoxCrime3/ProgressPopularidade
@onready var abertura: Control = $Base/Abertura
@onready var topo: Control = $Base/Topo
@onready var texto_pergunta: Label = $Base/Topo/BoxTopo/TextoPergunta
@onready var animation_botao_noticia: AnimationPlayer = $Base/Noticias/TextureNoticia/Control/AnimationBotaoNoticia
@onready var animation_botao_abertura: AnimationPlayer = $Base/Abertura/AnimationBotaoAbertura
@onready var rodape: Control = $Base/Rodape
@onready var pause_area: Control = $Base/PauseArea


func _ready() -> void:
	AudioPlayer.Iniciar()
	AudioPlayer.TocarBackground()
	abertura.modulate.a = 0
	create_tween().tween_property(abertura, "modulate:a", 1, 1.5)
	create_tween().tween_property(rodape, "modulate:a", 1, 1.5)
	create_tween().tween_property(pause_area, "modulate:a", 1, 1.5)	
	gameData = GameDataLoader.LoadGameData()
	criminalidade = gameData.Configuracoes.CriminalidadeInicial
	popularidade = gameData.Configuracoes.PopularidadeInicial
	dinheiro = gameData.Configuracoes.DinheiroInicial
	background.TempoTransicao = gameData.Configuracoes.TempoTransicao
	tempoEspera = gameData.Configuracoes.TempoTransicao
	timerEspera = tempoEspera	
	progress_crime.value = criminalidade
	progress_dinheiro.value = dinheiro
	progress_popularidade.value = popularidade
	animation_botao_noticia.play("botao")
	animation_botao_abertura.play("botao")

func _process(delta: float) -> void:
	match estado:
		Estados.EsperarAbertura:
			ProcessarTempoAbertura(delta)
		Estados.AnimarDia:
			ProcessarAnimarDia()		
		Estados.EsperarAnimarDia:
			pass
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
		Estados.EsperarFecharNoticia:
			pass
		Estados.FimDeTurno:			
			FinalizarTurno()
		Estados.FimDeJogo:
			pass
	
func ProcessarTempoAbertura(delta : float):
	timerAbertura -= delta
	if timerAbertura <= 0:
		estado = Estados.AnimarDia

func ProcessarAnimarDia():
	AudioPlayer.TocarForeground()
	estado = Estados.EsperarAnimarDia
	create_tween().tween_property(abertura, "modulate:a", 0, 0.8)
	await get_tree().create_timer(0.8).timeout
	create_tween().tween_property(topo, "modulate:a", 1, tempoMovimento)
	create_tween().tween_property(topo, "position:y", 40, tempoMovimento)
	await get_tree().create_timer(tempoMovimento).timeout
	create_tween().tween_property(texto_turno, "modulate:a", 1, tempoMovimento)
	estado = Estados.DefinirSugestao

func ProcessarMudarTarde():	
	estado = Estados.EsperarDia
	texto_turno.text = "Tarde"	
	douces.EsconderTexto()
	lourdes.EsconderTexto()	
	background.TransicaoTarde(popuUp, popuDown, crimeUp, custoUp)
	background.DefinirPredios(inclinacao)
	texto_pergunta.text = textoTransicao
	create_tween().tween_property(texto_pergunta, "modulate:a", 1, tempoMovimento)
	AnimarBarras()

func ProcessarDefinirSugestao():
	var disponiveisA = gameData.Sugestoes.filter(func (i : Sugestao) : return i.Conselheiro == 'Douces' and not sugestoesUsadas.has(i.Id))
	var disponiveisB = gameData.Sugestoes.filter(func (i : Sugestao) : return i.Conselheiro == 'Lurdes' and not sugestoesUsadas.has(i.Id))
	if len(disponiveisA) <= 0 or len(disponiveisB) <= 0:
		FinalizarJogo()
	sugestaoA = disponiveisA.pick_random() as Sugestao
	sugestaoB = disponiveisB.pick_random() as Sugestao
	sugestoesUsadas.append(sugestaoA.Id)
	sugestoesUsadas.append(sugestaoB.Id)	
	douces.DefinirTexto(sugestaoA.Texto, sugestaoA.Custo)
	lourdes.DefinirTexto(sugestaoB.Texto, sugestaoB.Custo)
	texto_pergunta.text = textoPergunta
	create_tween().tween_property(texto_pergunta, "modulate:a", 1, tempoMovimento)
	estado = Estados.EsperarEscolha
	
func ProcessarMostrarNoticia():
	estado = Estados.EsperarNoticia
	var possivel = gameData.Noticias.filter(func (i: Noticia) : return i.SugestaoId == ultimaSugestaoId)
	if len(possivel) > 0:
		noticiaAtual = possivel.pick_random() as Noticia
		titulo_noticia.texture = load(titulosNoticia.pick_random())
		texto_noticia.text = noticiaAtual.Texto
		create_tween().tween_property(texture_noticia, "modulate:a", 1, 0.5)
		await get_tree().create_timer(tempoEspera).timeout
	else:
		FecharNoticia()
	
func FecharNoticia():
	create_tween().tween_property(texture_noticia, "modulate:a", 0, 0.5)
	background.TransicaoManha()	
	create_tween().tween_property(texto_pergunta, "modulate:a", 0, 0.3)
	await get_tree().create_timer(tempoEspera).timeout
	estado = Estados.FimDeTurno
	
func FinalizarTurno():	
	timerEspera = tempoEspera
	dia += 1	
	estado = Estados.DefinirSugestao
	texto_turno.text = "Manhã"
	DefinirJogo()

func SelecionarSugestao(sugestao : Sugestao):	
	create_tween().tween_property(texto_pergunta, "modulate:a", 0, 0.5)
	ultimaSugestaoId  = sugestao.Id
	dinheiro -= sugestao.Custo
	dinheiro = clamp(dinheiro, 0, 100)
	popularidade += sugestao.Popularidade
	popularidade = clamp(popularidade, 0, 100)
	criminalidade += sugestao.Criminalidade
	criminalidade = clamp(criminalidade, 0, 100)
	
	popuUp = sugestao.Popularidade > 0
	popuDown = sugestao.Popularidade < 0
	crimeUp = sugestao.Criminalidade > 0
	custoUp = sugestao.Custo > 15
	await get_tree().create_timer(tempoEspera).timeout
	estado = Estados.MudarTarde	
	
func DefinirJogo():
	if dia < 10:
		texto_dia.text = "Mês 0" + str(dia)
	else:
		texto_dia.text = "Mês " + str(dia)	
		
	if dinheiro <= 0 or criminalidade >= 100 or dia > gameData.Configuracoes.LimiteDias:
		FinalizarJogo()
		
func AnimarBarras():
	create_tween().tween_property(progress_crime, "value", criminalidade, 0.5)
	create_tween().tween_property(progress_dinheiro, "value", dinheiro, 0.5)
	create_tween().tween_property(progress_popularidade, "value", popularidade, 0.5)
	
func FinalizarJogo():
	estado = Estados.FimDeJogo
	EstadoGlobal.Criminalidade = criminalidade
	EstadoGlobal.Popularidade = popularidade
	EstadoGlobal.Dinheiro = dinheiro
	EstadoGlobal.Inclinacao = inclinacao
	EstadoGlobal.GameData = gameData	
	create_tween().tween_property(progress_crime, "modulate:a", 0, 0.5)
	create_tween().tween_property(progress_crime, "modulate:a", 0, 0.5)
	create_tween().tween_property(progress_crime, "modulate:a", 0, 0.5)
	create_tween().tween_property(topo, "modulate:a", 0, 0.5)
	create_tween().tween_property(texture_noticia, "modulate:a", 0, 0.5)
	create_tween().tween_property(douces, "modulate:a", 0, 0.5)
	create_tween().tween_property(lourdes, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout	
	SceneManager.change_to(load("res://Scenes/Victory/Victory.tscn"))

func _on_background_finalizado() -> void:	
	if estado == Estados.EsperarDia:
		estado = Estados.MostrarNoticia

func _on_douces_selecionar() -> void:
	if estado == Estados.EsperarEscolha:
		inclinacao += 1
		lourdes.DefinirExpressao(Conselheiro.Expressoes.Nao)
		SelecionarSugestao(sugestaoA)
	
func _on_lourdes_selecionar() -> void:
	if estado == Estados.EsperarEscolha:
		inclinacao -= 1
		douces.DefinirExpressao(Conselheiro.Expressoes.Nao)
		SelecionarSugestao(sugestaoB)

func _on_pause_pressed() -> void:
	pause_menu.visible = true
	AudioPlayer.MutarForeground()
	get_tree().paused = true

func _on_pause_menu_resumed() -> void:
	pause_menu.visible = false
	AudioPlayer.TocarForeground()
	get_tree().paused = false

func _on_fechar_noticia_pressed() -> void:
	if estado == Estados.EsperarNoticia:
		estado = Estados.EsperarFecharNoticia
		FecharNoticia()

func _on_touch_screen_button_pressed() -> void:
	if estado == Estados.EsperarAbertura:
		estado = Estados.AnimarDia
