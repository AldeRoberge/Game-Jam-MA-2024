extends Node

# Constants for scoring.
const MAX_PLAYER_SCORE := 3000 # The score required for a player to win.
const LAST_MAN_SCORE := 1000 # Bonus score awarded to the last remaining player.
const COIN_SCORE := 50 # Score awarded for collecting a coin.

# Array to track the scores of players. Each index corresponds to a player's score.
var player_scores: Array[int] = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset() # Initialize or reset player scores.
	pass # Replace with any additional setup code.

# Resets all player scores to zero.
func reset() -> void:
	for i in range(player_scores.size()):
		player_scores[i] = 0

# Adds a specified score to a player's total. If no score is specified, awards the LAST_MAN_SCORE.
# - `id`: The player's ID (index in the player_scores array).
# - `value`: The score to add. If omitted, defaults to awarding LAST_MAN_SCORE.
func add_score_to_player(id: int, value: int = -1):
	if value == -1:
		player_scores[id] += LAST_MAN_SCORE # Award the last man standing bonus.
	else:
		player_scores[id] += value # Add the specified score.

	# Check if the player's score has reached or exceeded the winning score.
	if player_scores[id] >= MAX_PLAYER_SCORE:
		# Player wins: Transition to the end video scene.
		get_tree().change_scene_to_file("res://assets/videos/video-player-end.tscn")
	elif value == -1:
		# If the last man standing bonus is awarded, restart the main scene.
		get_tree().change_scene_to_file("res://scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Update logic can be added here if needed.

# Returns the index of the player who has reached the maximum score.
# If no player has won yet, returns -1.
func get_winner_index() -> int:
	for i in range(player_scores.size()):
		if player_scores[i] >= MAX_PLAYER_SCORE:
			return i # Return the index of the winning player.
	return -1 # No player has reached the winning score.
