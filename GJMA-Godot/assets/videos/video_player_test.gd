extends Control

@export var next_scene: PackedScene

@onready var loading_circle := $LoadingCircle/AnimatedSprite2D as AnimatedSprite2D
@onready var video := $CenterContainer/VideoStreamPlayer as VideoStreamPlayer

func _get_input_start() -> bool:
	for device in range(3):
		if Input.is_joy_button_pressed(device, JOY_BUTTON_START):
			return true
	
	return false

func _go_to_next_scene():
	get_tree().change_scene_to_packed(next_scene)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_circle.animation_finished.connect(_go_to_next_scene)
	video.finished.connect(_go_to_next_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _get_input_start():
		if not loading_circle.is_playing():
			loading_circle.play()
			loading_circle.show()
	else:
		loading_circle.stop()
		loading_circle.hide()
	pass
