extends Control

const MAX_NIGHTS = 3
const DEBUG = false
const TITLE_SCENE = "res://title.tscn"
const PARTNER_BASE_TIME = 2.0
const PARTNER_TIME_PER_CHAR = 0.06
const PARTNER_FADE_TIME = 0.4

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
@onready var partner_name: Label = %PartnerName
@onready var partner_line: RichTextLabel = %PartnerLine
@onready var partner_box: PanelContainer = %PartnerBox

var culprit_id: String = ""
var current_night: int = 1
var current_case: Dictionary
var partner_tween: Tween
var investigations_done: int = 0

func _ready() -> void:
	current_case = GameData.CASES[CaseManager.selected_case_id]
	partner_name.text = current_case["partner"]["name"]
	create_location_buttons()
	create_suspect_buttons()
	create_accuse_options()
	accuse_button.pressed.connect(open_accusation.bind(true))
	start_investigation_button.pressed.connect(start_investigation)
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
	partner_box.modulate.a = 0.0
	start_game()


# ========== LÓGICA ==========

func start_game() -> void:
	culprit_id = current_case["suspects"].pick_random()	
	current_night = 1
	investigations_done = 0
	journal.clear()
	update_night_label()
	if DEBUG:
		print("[DEBUG] Culpada sorteada: ", culprit_id)
	show_intro()

func culprit_has_feature(feature_id: String) -> bool:
	return feature_id in GameData.LEGENDS[culprit_id]["features"]

func investigate(loc_id: String) -> void:
	investigations_done += 1
	var location = GameData.LOCATIONS[loc_id]
	var has_feature = culprit_has_feature(location["feature"])
	var clue: String
	if has_feature:
		clue = location["found"].pick_random()
	else:
		clue = location["nothing"].pick_random()
	add_journal_entry(location["name"], clue)
	partner_say("found" if has_feature else "nothing")
	advance_night()

func advance_night() -> void:
	if current_night >= MAX_NIGHTS:
		end_investigations()
	else:
		current_night += 1
		update_night_label()

func accuse(legend_id: String) -> void:
	var won = legend_id == culprit_id
	var old_rank = ProgressManager.get_rank_index()
	var points = calculate_points(won, old_rank)
	ProgressManager.add_points(points)
	show_ending(won, points, old_rank)

func calculate_points(won: bool, rank_index: int) -> int:
	if won:
		var saved_nights = MAX_NIGHTS - investigations_done
		return GameData.SCORE_WIN + saved_nights * GameData.SCORE_PER_SAVED_NIGHT
	if rank_index >= GameData.PENALTY_FROM_RANK:
		return -GameData.SCORE_PENALTY
	return 0

func restart_game() -> void:
	get_tree().reload_current_scene()
	
func go_to_menu() -> void:
	get_tree().change_scene_to_file(TITLE_SCENE)
	
func start_investigation() -> void:
	intro_overlay.hide()
	partner_say("start")

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
	journal.append_text("[i]O sol está nascendo. Revise as pistas e clique em Acusar para apontar a culpada.[/i]\n")
	for button in location_buttons.get_children():
		button.disabled = true
	partner_line.append_text("\n\n" + get_partner_line("dawn"))
	show_partner_box()
	
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

func show_ending(won: bool, points: int, old_rank: int) -> void:
	accuse_overlay.hide()
	var culprit = GameData.LEGENDS[culprit_id]
	if won:
		end_title.text = "Você descobriu a visagem!"
	else:
		end_title.text = "A visagem venceu..."
	end_text.text = "Era [b]%s[/b].\n\n%s" % [culprit["name"], culprit["story"]]
	end_overlay.show()
	var partner = current_case["partner"]
	end_text.text += get_score_text(points, old_rank)
	end_text.text += "\n\n[b]%s:[/b] %s" % [partner["name"], get_partner_line("win" if won else "lose")]

func fill_legends_text() -> void:
	legends_text.clear()
	for legend_id in current_case["suspects"]:
		var legend = GameData.LEGENDS[legend_id]
		legends_text.append_text("[b]%s[/b]\n%s\n\n" % [legend["name"], legend["profile"]])

func show_intro() -> void:
	case_title.text = current_case["title"]
	intro_text.text = current_case["intro"]
	intro_overlay.show()

func get_partner_line(moment: String) -> String:
	return current_case["partner"]["lines"][moment].pick_random()

func partner_say(moment: String) -> void:
	partner_line.text = get_partner_line(moment)
	show_partner_box()

func show_partner_box() -> void:
	if partner_tween:
		partner_tween.kill()
	var read_time = PARTNER_BASE_TIME + partner_line.get_parsed_text().length() * PARTNER_TIME_PER_CHAR
	partner_tween = create_tween()
	partner_tween.tween_property(partner_box, "modulate:a", 1.0, PARTNER_FADE_TIME)
	partner_tween.tween_interval(read_time)
	partner_tween.tween_property(partner_box, "modulate:a", 0.0, PARTNER_FADE_TIME)

func get_score_text(points: int, old_rank: int) -> String:
	var new_rank = ProgressManager.get_rank_index()
	var rank = GameData.RANKS[new_rank]
	var text = "\n\n[b]%+d pontos[/b]  ·  Total: %d  ·  Patente: %s" % [points, ProgressManager.total_points, rank["name"]]
	if new_rank > old_rank:
		text += "\n\n[b]Nova patente: %s![/b]\n[i]%s[/i]" % [rank["name"], rank["line"]]
	return text
