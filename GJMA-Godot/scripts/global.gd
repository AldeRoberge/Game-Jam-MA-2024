extends Node

var player_scores: Array[int] = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reset() -> void:
	for i in range(player_scores.size()):
		player_scores[i] = 0

func add_score_to_player(id:int):
	player_scores[id] += 1
	if player_scores[id] >= 3:
		get_tree().change_scene_to_file("res://assets/videos/video-player-end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_winner_index():
	return player_scores.find(3)
