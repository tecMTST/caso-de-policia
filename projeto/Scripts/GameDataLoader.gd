extends Node
class_name GameDataLoader

static func LoadGameData() -> GameData:
	var gameDataFile = "res://Scripts/Data/GameData.json"
	var result =  JsonClassConverter.json_file_to_class(GameData, gameDataFile)
	return result
