extends Node

const MAX_PLAYER_SCORE := 3000
const LAST_MAN_SCORE := 1000
const COIN_SCORE := 100
var player_scores: Array[int] = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()
	pass # Replace with function body.

func reset() -> void:
	for i in range(player_scores.size()):
		player_scores[i] = 0

func add_score_to_player(id:int, value:int = -1):
	if value == -1:
		player_scores[id] += LAST_MAN_SCORE
	else:
		player_scores[id] += value
	
	if player_scores[id] >= MAX_PLAYER_SCORE:
		get_tree().change_scene_to_file("res://assets/videos/video-player-end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_winner_index():
	for i in range(player_scores.size()):
		if player_scores[i] >= MAX_PLAYER_SCORE:
			return i 
	return -1
