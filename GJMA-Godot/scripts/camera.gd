extends Node2D

@export var max_scroll_speed := 1.0
@export var time_to_night_seconds := 60.0

@onready var sunset := $Sunset as Sprite2D
@onready var nightfall := $Nightfall as Sprite2D
@onready var dawn := $Dawn as Sprite2D
@onready var night := $Night as Sprite2D
@onready var timer := $Timer as Timer

var progress := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(time_to_night_seconds)
	pass # Replace with function body.

func _set_progress(value:float):
	if (value < 33) :
		sunset.modulate.a = 1.0 - value / 33
		nightfall.modulate.a = value / 33
		dawn.modulate.a = 0
		night.modulate.a = 0
	elif (value < 66) :
		sunset.modulate.a = 0
		nightfall.modulate.a = 1.0 - (value - 33) / 33
		dawn.modulate.a = (value - 33) / 33
		night.modulate.a = 0
	elif (value < 100) :
		dawn.modulate.a = 1.0 - (value - 66) / 33
		night.modulate.a = (value - 66) / 33
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress = (1.0 - timer.time_left / timer.wait_time) * 100
	_set_progress(progress)
	self.position.y -= max_scroll_speed * delta * progress
	pass
