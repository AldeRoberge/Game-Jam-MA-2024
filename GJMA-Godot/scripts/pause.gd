extends Node

var old_start = true

@onready var sound_pause := $"Sound Pause" as AudioStreamPlayer2D
@onready var sound_resume := $"Sound Resume" as AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _get_input_start() -> bool:
	for device in range(3):
		if Input.is_joy_button_pressed(device, JOY_BUTTON_START):
			return true
	
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var start = _get_input_start()
	if start and old_start != start:
		if get_tree().paused:
			sound_resume.play()
		else:
			sound_pause.play()
		
		get_tree().paused = !get_tree().paused
		
		
	old_start = start
	pass
