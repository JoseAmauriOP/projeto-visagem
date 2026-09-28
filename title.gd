extends Control

const GAME_SCENE = "res://game.tscn"

@onready var start_button: Button = %StartButton
@onready var how_to_button: Button = %HowToButton
@onready var how_to_overlay: ColorRect = %HowToOverlay
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	start_button.pressed.connect(start_game)
	how_to_button.pressed.connect(how_to_overlay.show)
	close_button.pressed.connect(how_to_overlay.hide)
	how_to_overlay.hide()

func start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
