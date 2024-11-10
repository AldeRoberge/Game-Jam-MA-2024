extends Node2D

@export var max_scroll_speed := 1.0
@export var time_to_night_seconds := 60.0

# A reference to the player #1
@export var start_area: Area2D
@export var start_top_limit: StaticBody2D
@export var players: Array[Player]

@onready var sunset := $Sunset as Sprite2D
@onready var nightfall := $Nightfall as Sprite2D
@onready var dawn := $Dawn as Sprite2D
@onready var night := $Night as Sprite2D
@onready var timer := $Timer as Timer


@onready var target_position_y := self.position.y

var is_started = false


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
	if not is_started:
		# Wait that player jump up a bit before beginning the game.
		var readyCount := 0
		var min_start_position = target_position_y - 100
		for i in range(players.size()):
			if (Input.get_connected_joypads().size() > i
				and is_instance_valid(players[i])
				and start_area.get_overlapping_bodies().find(players[i]) != -1):
				readyCount += 1
		
		if readyCount >= Input.get_connected_joypads().size():
			timer.start(time_to_night_seconds)
			start_top_limit.queue_free()
			is_started = true
	else:
		# Thats the super scrolling code.
		var top_screen_limit = target_position_y - 100
		for i in range(players.size()):
			if is_instance_valid(players[i]) and players[i].position.y < top_screen_limit:
				target_position_y = players[i].position.y

		var progress = (1.0 - timer.time_left / timer.wait_time) * 100
		_set_progress(progress)
		target_position_y -= max_scroll_speed * delta * progress
		
		#smoothly move the camera to the highest player position
		position.y = lerp(position.y, target_position_y, 0.01)
		
		var player_alive_count = 0
		for player in players:
			if is_instance_valid(player) and not player._is_dead:
				player_alive_count += 1
		
		player_alive_count == 1
		for i in range(players.size()):
			if is_instance_valid(players[i]) && !players[i]._is_dead:
				Global.add_score_to_player(i)

	pass
