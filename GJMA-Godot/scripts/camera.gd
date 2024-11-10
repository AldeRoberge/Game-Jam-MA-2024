extends Node2D

@export var max_scroll_speed := 1.0
@export var time_to_night_seconds := 60.0

# A reference to the player #1
@export var player1: Player
@export var player2: Player
@export var player3: Player
@export var player4: Player

@onready var sunset := $Sunset as Sprite2D
@onready var nightfall := $Nightfall as Sprite2D
@onready var dawn := $Dawn as Sprite2D
@onready var night := $Night as Sprite2D
@onready var timer := $Timer as Timer

var progress := 0
@onready var target_position_y := self.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if timer.is_stopped():
		# Wait that player jump up a bit before beginning the game.
		var min_start_position = target_position_y - 100
		if (is_instance_valid(player1) and player1.position.y < min_start_position) and \
		(is_instance_valid(player2) and player2.position.y < min_start_position) and \
		(is_instance_valid(player3) and player3.position.y < min_start_position) and \
		(is_instance_valid(player4) and player4.position.y < min_start_position):
			timer.start(time_to_night_seconds)
	else:
		# Thats the super scrolling code.
		var top_screen_limit = target_position_y - 100
		if is_instance_valid(player1) and player1.position.y < top_screen_limit:
			target_position_y = player1.position.y
		if is_instance_valid(player2) and player2.position.y < top_screen_limit:
			target_position_y = player2.position.y
		if is_instance_valid(player3) and player3.position.y < top_screen_limit:
			target_position_y = player3.position.y
		if is_instance_valid(player4) and player4.position.y < top_screen_limit:
			target_position_y = player4.position.y

		var progress = (1.0 - timer.time_left / timer.wait_time) * 100
		_set_progress(progress)
		target_position_y -= max_scroll_speed * delta * progress
		
		#smoothly move the camera to the highest player position
		position.y = lerp(position.y, target_position_y, 0.01)
	pass
