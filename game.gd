extends Control

const MAX_NIGHTS = 3
const DEBUG = false
const TITLE_SCENE = "res://title.tscn"

@onready var location_buttons: VBoxContainer = %LocationButtons
@onready var suspect_buttons: VBoxContainer = %SuspectButtons
@onready var night_label: Label = %NightLabel
@onready var journal: RichTextLabel = %Journal
@onready var accuse_button: Button = %AccuseButton
@onready var accuse_overlay: ColorRect = %AccuseOverlay
@onready var accuse_options: VBoxContainer = %AccuseOptions
@onready var cancel_button: Button = %CancelButton
@onready var end_overlay: ColorRect = %EndOverlay
@onready var end_title: Label = %EndTitle
@onready var end_text: RichTextLabel = %EndText
@onready var restart_button: Button = %RestartButton
@onready var back_to_menu_button: Button = %BackToMenuButton
@onready var legends_button: Button = %LegendsButton
@onready var accuse_legends_button: Button = %AccuseLegendsButton
@onready var legends_overlay: ColorRect = %LegendsOverlay
@onready var legends_text: RichTextLabel = %LegendsText
@onready var close_legends_button: Button = %CloseLegendsButton
@onready var intro_overlay: ColorRect = %IntroOverlay
@onready var case_title: Label = %CaseTitle
@onready var intro_text: RichTextLabel = %IntroText
@onready var start_investigation_button: Button = %StartInvestigationButton

var culprit_id: String = ""
var current_night: int = 1
var current_case: Dictionary

func _ready() -> void:
	current_case = GameData.CASES[CaseManager.selected_case_id]
	create_location_buttons()
	create_suspect_buttons()
	create_accuse_options()
	accuse_button.pressed.connect(open_accusation.bind(true))
	start_investigation_button.pressed.connect(intro_overlay.hide)
	cancel_button.pressed.connect(close_accusation)
	restart_button.pressed.connect(restart_game)
	back_to_menu_button.pressed.connect(go_to_menu)
	accuse_overlay.hide()
	end_overlay.hide()
	fill_legends_text()
	legends_button.pressed.connect(legends_overlay.show)
	accuse_legends_button.pressed.connect(legends_overlay.show)
	close_legends_button.pressed.connect(legends_overlay.hide)
	legends_overlay.hide()
	start_game()


# ========== LÓGICA ==========

func start_game() -> void:
	culprit_id = current_case["suspects"].pick_random()	
	current_night = 1
	journal.clear()
	update_night_label()
	if DEBUG:
		print("[DEBUG] Culpada sorteada: ", culprit_id)
	show_intro()

func culprit_has_feature(feature_id: String) -> bool:
	return feature_id in GameData.LEGENDS[culprit_id]["features"]

func investigate(loc_id: String) -> void:
	var location = GameData.LOCATIONS[loc_id]
	var clue: String
	if culprit_has_feature(location["feature"]):
		clue = location["found"].pick_random()
	else:
		clue = location["nothing"].pick_random()
	add_journal_entry(location["name"], clue)
	advance_night()

func advance_night() -> void:
	if current_night >= MAX_NIGHTS:
		end_investigations()
	else:
		current_night += 1
		update_night_label()

func accuse(legend_id: String) -> void:
	var won = legend_id == culprit_id
	show_ending(won)

func restart_game() -> void:
	get_tree().reload_current_scene()
	
func go_to_menu() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)
	


# ========== INTERFACE ==========

func create_location_buttons() -> void:
	for loc_id in current_case["locations"]:
		var button = Button.new()
		button.text = GameData.LOCATIONS[loc_id]["name"]
		button.pressed.connect(investigate.bind(loc_id))
		location_buttons.add_child(button)

func create_suspect_buttons() -> void:
	for legend_id in current_case["suspects"]:
		var legend_name = GameData.LEGENDS[legend_id]["name"]
		var button = Button.new()
		button.text = legend_name
		button.toggle_mode = true
		button.toggled.connect(_on_suspect_toggled.bind(button, legend_name))
		suspect_buttons.add_child(button)

func _on_suspect_toggled(is_marked: bool, button: Button, legend_name: String) -> void:
	if is_marked:
		button.text = "X  " + legend_name
		button.modulate = Color(1, 1, 1, 0.4)
	else:
		button.text = legend_name
		button.modulate = Color(1, 1, 1, 1)

func update_night_label() -> void:
	night_label.text = "Noite %d de %d" % [current_night, MAX_NIGHTS]

func add_journal_entry(place_name: String, clue: String) -> void:
	journal.append_text("[b]Noite %d — %s[/b]\n%s\n\n" % [current_night, place_name, clue])

func end_investigations() -> void:
	night_label.text = "Amanhecer"
	journal.append_text("[i]O sol está nascendo. Chegou a hora de apontar a culpada.[/i]\n")
	for button in location_buttons.get_children():
		button.disabled = true
	open_accusation(false)
	
func create_accuse_options() -> void:
	for legend_id in current_case["suspects"]:
		var button = Button.new()
		button.text = GameData.LEGENDS[legend_id]["name"]
		button.pressed.connect(accuse.bind(legend_id))
		accuse_options.add_child(button)
		
func open_accusation(can_cancel: bool) -> void:
	cancel_button.visible = can_cancel
	accuse_overlay.show()

func close_accusation() -> void:
	accuse_overlay.hide()

func show_ending(won: bool) -> void:
	accuse_overlay.hide()
	var culprit = GameData.LEGENDS[culprit_id]
	if won:
		end_title.text = "Você descobriu a visagem!"
	else:
		end_title.text = "A visagem venceu..."
	end_text.text = "Era [b]%s[/b].\n\n%s" % [culprit["name"], culprit["story"]]
	end_overlay.show()

func fill_legends_text() -> void:
	legends_text.clear()
	for legend_id in current_case["suspects"]:
		var legend = GameData.LEGENDS[legend_id]
		legends_text.append_text("[b]%s[/b]\n%s\n\n" % [legend["name"], legend["profile"]])

func show_intro() -> void:
	case_title.text = current_case["title"]
	intro_text.text = current_case["intro"]
	intro_overlay.show()
