extends Node

const SAVE_PATH = "res://progress.json"

var total_points: int = 0

func _ready() -> void:
	load_progress()

func add_points(amount: int) -> void:
	total_points = maxi(total_points + amount, 0)
	save_progress()

func get_rank_index() -> int:
	var index = 0
	for i in GameData.RANKS.size():
		if total_points >= GameData.RANKS[i]["points"]:
			index = i
	return index

func save_progress() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		print("Erro ao salvar progresso: ", FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify({"total_points": total_points}))
	file.close()

func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data is Dictionary and data.has("total_points"):
		total_points = int(data["total_points"])
