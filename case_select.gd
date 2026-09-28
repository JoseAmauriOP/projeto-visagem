extends Control

const GAME_SCENE = "res://game.tscn"
const TITLE_SCENE = "res://title.tscn"

@onready var case_buttons: VBoxContainer = %CaseButtons
@onready var back_button: Button = %BackButton


func _ready() -> void:
	create_case_buttons()
	back_button.pressed.connect(go_back)

func create_case_buttons() -> void:
	for case_id in GameData.CASES:
		var case_data = GameData.CASES[case_id]
		var button = Button.new()
		button.text = case_data["title"]
		button.custom_minimum_size = Vector2(360, 0)
		if case_data["playable"]:
			button.pressed.connect(select_case.bind(case_id))
		else:
			button.text += "  (em breve)"
			button.disabled = true
		case_buttons.add_child(button)

func select_case(case_id: String) -> void:
	CaseManager.selected_case_id = case_id
	get_tree().change_scene_to_file(GAME_SCENE)

func go_back() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)
