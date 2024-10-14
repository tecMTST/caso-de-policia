extends Node2D

enum States {
	Choose,
	SelectSuggestion,
	ShowNews,
	WaitDay,
	WaitNews
}

@onready var pause_menu: PauseMenu = $PauseMenuOverlay/PauseMenu
@onready var news_label: Label = $NewsLabel

var state : States = States.SelectSuggestion
var gameData : GameData
var security : float
var popularity : float
var day : int = 0
var usedSuggestions : Array[int] = []
var dayTime : float = 0
var dayTimer : float = 0
var currentCost : float  = 0
var cash : float  = 0

var suggestionA : Suggestion
var suggestionB : Suggestion
var CurrentNews : News
var lastSuggestionId : int  = 0

func _ready() -> void:
	gameData = GameDataLoader.LoadGameData()
	security = gameData.InitialStatus.Security
	popularity = gameData.InitialStatus.Popularity
	dayTime = gameData.InitialStatus.DayTime
	dayTimer = dayTime
	cash = gameData.InitialStatus.Cash

func _process(delta: float) -> void:
	match state:
		States.SelectSuggestion:
			ProcessSelectSuggestionState(delta)
		States.WaitDay:
			ProcessWaitDayState(delta)
		States.ShowNews:
			ProcessShowNewsState(delta)
		States.WaitNews:
			ProcessWaitNewsState(delta)
		States.Choose:
			ProcessChooseState(delta)
	GameSet()

func ProcessWaitDayState(delta : float):
	#start Animate Popups
	if dayTimer <= 0:
		dayTimer = dayTime
		day += 1
		cash -= currentCost		
		state = States.ShowNews		
	else:
		dayTimer -= delta

func ProcessSelectSuggestionState(delta : float):
	var availableA = gameData.Suggetions.filter(func (i : Suggestion) : return i.Candidate == 'Douces' and not usedSuggestions.has(i.Id))
	var availableB = gameData.Suggetions.filter(func (i : Suggestion) : return i.Candidate == 'Lurdes' and not usedSuggestions.has(i.Id))
	if len(availableA) <= 0 or len(availableB) <= 0:
		pass #Game Over -> result
	suggestionA = availableA.pick_random()
	suggestionB = availableB.pick_random()
	usedSuggestions.append(suggestionA.Id)
	usedSuggestions.append(suggestionB.Id)
	#Animate intro Here
	state = States.Choose		
	
func ProcessShowNewsState(delta: float):
	var possible = gameData.News.filter(func (i: News) : return i.SugestionId == lastSuggestionId)
	CurrentNews = possible.pick_random() as News
	news_label.text = CurrentNews.Text

func ProcessChooseState(delta : float):
	pass
	
func ProcessWaitNewsState(delta : float):
	pass

func GameSet():
	if cash <= 0:
		# Gameover Baknrupt
		SceneManager.change_to(load("res://Scenes/Defeat/Defeat.tscn"))

func _on_vitoria_cta_pressed():
	SceneManager.change_to(load("res://Scenes/Victory/Victory.tscn"))

func _on_derrota_cta_pressed():
	SceneManager.change_to(load("res://Scenes/Defeat/Defeat.tscn"))

func _on_pause_cta_pressed():
	pause_menu.pause()

func _on_pause_menu_paused():
	pause_menu.show()

func _on_pause_menu_resumed():
	pause_menu.hide()
