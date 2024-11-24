extends Node2D

@export var max_scroll_speed := 1.0 # Maximum scrolling speed for the camera.
@export var time_to_night_seconds := 60.0 # Time in seconds for the transition from sunset to night.

# References for the starting area and player setup.
@export var start_area: Area2D # Area where the players start the game.
@export var start_top_limit: StaticBody2D # Boundary to prevent players from going too high at the start.
@export var players: Array[Player] # Array of players in the game.

# References to the sprites used for visual effects during the day-night cycle.
@onready var sunset := $Sunset as Sprite2D
@onready var nightfall := $Nightfall as Sprite2D
@onready var dawn := $Dawn as Sprite2D
@onready var night := $Night as Sprite2D
@onready var timer := $Timer as Timer # Timer to manage the day-night transition.

# Target Y position for the camera to smoothly follow the highest player.
@onready var target_position_y := self.position.y

# State variable to indicate if the game has started.
var is_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with any necessary initialization code.

# Adjusts the transparency (alpha) of the day-night cycle sprites based on progress.
func _set_progress(value: float):
	if value < 33: # Early phase: Sunset transitioning to nightfall.
		sunset.modulate.a = 1.0 - value / 33
		nightfall.modulate.a = value / 33
		dawn.modulate.a = 0
		night.modulate.a = 0
	elif value < 66: # Middle phase: Nightfall transitioning to dawn.
		sunset.modulate.a = 0
		nightfall.modulate.a = 1.0 - (value - 33) / 33
		dawn.modulate.a = (value - 33) / 33
		night.modulate.a = 0
	elif value < 100: # Final phase: Dawn transitioning to night.
		dawn.modulate.a = 1.0 - (value - 66) / 33
		night.modulate.a = (value - 66) / 33
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_started:
		# Wait for players to jump into the starting area before starting the game.
		var readyCount := 0

		for i in range(players.size()):
			if (Input.get_connected_joypads().size() > i
				and is_instance_valid(players[i])
				and start_area.get_overlapping_bodies().find(players[i]) != -1):
				readyCount += 1
		
		# Start the game once all connected players are ready.
		if readyCount >= Input.get_connected_joypads().size():
			timer.start(time_to_night_seconds) # Begin the day-night transition timer.
			start_top_limit.queue_free() # Remove the initial top limit.
			is_started = true
	else:
		# Scrolling logic: Adjust the target Y position based on the highest player.
		var top_screen_limit = target_position_y - 100
		
		for i in range(players.size()):
			if is_instance_valid(players[i]) and players[i].position.y < top_screen_limit:
				target_position_y = players[i].position.y

		# Update the progress of the day-night cycle based on the timer.
		var progress = (1.0 - timer.time_left / timer.wait_time) * 100
		_set_progress(progress)
		target_position_y -= max_scroll_speed * delta * progress
		
		# Smoothly move the camera towards the target Y position.
		position.y = lerp(position.y, target_position_y, 0.01)
		
		# Count the number of players still alive.
		var player_alive_count = 0
		
		for player in players:
			if is_instance_valid(player) and not player._is_dead:
				player_alive_count += 1
		
		# Award score to the last remaining player if only one is alive.

		# TODO re-add
		if player_alive_count == 0:
			for i in range(players.size()):
				if is_instance_valid(players[i]) && !players[i]._is_dead:
					Global.add_score_to_player(i)

	pass
