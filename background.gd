extends Control

const ZOOM = 1.08
const ZOOM_TIME = 15.0

@onready var image: TextureRect = $Image


func _ready() -> void:
	update_pivot()
	image.resized.connect(update_pivot)
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(image, "scale", Vector2(ZOOM, ZOOM), ZOOM_TIME)
	tween.tween_property(image, "scale", Vector2.ONE, ZOOM_TIME)

func update_pivot() -> void:
	image.pivot_offset = image.size / 2
