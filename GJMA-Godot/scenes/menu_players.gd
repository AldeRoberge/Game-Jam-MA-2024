extends Control

@export var player1_alive := preload("res://assets/sprites/players/p1/player1-face.png") as Texture
@export var player1_dead := preload("res://assets/sprites/players/p1/player1-face-dead.png") as Texture

@export var player2_alive := preload("res://assets/sprites/players/p2/player2-face.png") as Texture
@export var player2_dead := preload("res://assets/sprites/players/p2/player2-face-dead.png") as Texture

@export var player3_alive := preload("res://assets/sprites/players/p3/player3-face.png") as Texture
@export var player3_dead := preload("res://assets/sprites/players/p3/player3-face-dead.png") as Texture

@export var player4_alive := preload("res://assets/sprites/players/p4/player4-face.png") as Texture
@export var player4_dead := preload("res://assets/sprites/players/p4/player4-face-dead.png") as Texture

@onready var playersFaces: Array[TextureRect] = [
	$"Heads/Player 1 Face",
	$"Heads/Player 2 Face",
	$"Heads/Player 3 Face",
	$"Heads/Player 4 Face"
]

@export var player1: Player
@export var player2: Player
@export var player3: Player
@export var player4: Player

@onready var playersTexts: Array[RichTextLabel] = [
	$"Heads/Player 1 Text",
	$"Heads/Player 2 Text",
	$"Heads/Player 3 Text",
	$"Heads/Player 4 Text"
]

@onready var playersScores: Array[RichTextLabel] = [
	$"Scores/Player 1 Score",
	$"Scores/Player 2 Score",
	$"Scores/Player 3 Score",
	$"Scores/Player 4 Score"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(playersTexts.size()):
		if Input.get_connected_joypads().size() <= i:
			playersFaces[i].hide()
			playersTexts[i].hide()
			playersScores[i].hide()
	
	
	# Connect death signals to corresponding methods
	
	if (is_instance_valid(player1) == false):
		print("Player are not valid, did you start this scene from the main scene?")
	
	player1.signal_on_death.connect(_on_player1_dead)
	player2.signal_on_death.connect(_on_player2_dead)
	player3.signal_on_death.connect(_on_player3_dead)
	player4.signal_on_death.connect(_on_player4_dead)

	# Set initial player textures based on their alive status
	_update_player_texture(player1, playersFaces[0], player1_alive, player1_dead)
	_update_player_texture(player2, playersFaces[1], player2_alive, player2_dead)
	_update_player_texture(player3, playersFaces[2], player3_alive, player3_dead)
	_update_player_texture(player4, playersFaces[3], player4_alive, player4_dead)

func _process(delta: float) -> void:
	for i in range(playersScores.size()):
		playersScores[i].text = "[center]P"+str(i+1)+"[/center]\n[center]" + \
		str(Global.player_scores[i]) + \
		"/" + \
		str(Global.MAX_PLAYER_SCORE) + \
		"[/center]"

# Helper function to update texture based on player's alive status
func _update_player_texture(player: Player, texture_rect: TextureRect, alive_texture: Texture, dead_texture: Texture) -> void:
	if !player._is_dead:
		texture_rect.texture = alive_texture
	else:
		texture_rect.texture = dead_texture

# Signal handler for player 1's death
func _on_player1_dead() -> void:
	playersFaces[0].texture = player1_dead
	_blink_texture(playersFaces[0])
	

# Signal handler for player 2's death
func _on_player2_dead() -> void:
	playersFaces[1].texture = player2_dead
	_blink_texture(playersFaces[1])

# Signal handler for player 3's death
func _on_player3_dead() -> void:
	playersFaces[2].texture = player3_dead
	_blink_texture(playersFaces[2])

# Signal handler for player 4's death
func _on_player4_dead() -> void:
	playersFaces[3].texture = player4_dead
	_blink_texture(playersFaces[3])
	
# Blink animation function
# Blink animation function
func _blink_texture(texture_rect: TextureRect) -> void:
	# Create a tween and add it as a child to ensure it doesn't get garbage-collected
	var blink_tween = create_tween()
	
	# Animate the alpha to 0 (invisible) and back to 1 (fully visible) for a blinking effect
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 0), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(texture_rect, "modulate", Color(1, 1, 1, 1), 0.25).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
