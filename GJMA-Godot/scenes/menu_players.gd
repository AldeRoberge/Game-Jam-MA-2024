extends Control

@export var player1_alive := preload("res://assets/sprites/players/p1/player1-face.png") as Texture
@export var player1_dead := preload("res://assets/sprites/players/p1/player1-face-dead.png") as Texture

@export var player2_alive := preload("res://assets/sprites/players/p2/player2-face.png") as Texture
@export var player2_dead := preload("res://assets/sprites/players/p2/player2-face-dead.png") as Texture

@export var player3_alive := preload("res://assets/sprites/players/p3/player3-face.png") as Texture
@export var player3_dead := preload("res://assets/sprites/players/p3/player3-face-dead.png") as Texture

@export var player4_alive := preload("res://assets/sprites/players/p4/player4-face.png") as Texture
@export var player4_dead := preload("res://assets/sprites/players/p4/player4-face-dead.png") as Texture

@export var player1_texture: TextureRect
@export var player2_texture: TextureRect
@export var player3_texture: TextureRect
@export var player4_texture: TextureRect

@export var player1: Player
@export var player2: Player
@export var player3: Player
@export var player4: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect death signals to corresponding methods
	
	if (is_instance_valid(player1) == false):
		print("Player are not valid, did you start this scene from the main scene?")
	
	player1.signal_on_death.connect(_on_player1_dead)
	player2.signal_on_death.connect(_on_player2_dead)
	player3.signal_on_death.connect(_on_player3_dead)
	player4.signal_on_death.connect(_on_player4_dead)

	# Set initial player textures based on their alive status
	_update_player_texture(player1, player1_texture, player1_alive, player1_dead)
	_update_player_texture(player2, player2_texture, player2_alive, player2_dead)
	_update_player_texture(player3, player3_texture, player3_alive, player3_dead)
	_update_player_texture(player4, player4_texture, player4_alive, player4_dead)

# Helper function to update texture based on player's alive status
func _update_player_texture(player: Player, texture_rect: TextureRect, alive_texture: Texture, dead_texture: Texture) -> void:
	if !player._is_dead:
		texture_rect.texture = alive_texture
	else:
		texture_rect.texture = dead_texture

# Signal handler for player 1's death
func _on_player1_dead() -> void:
	player1_texture.texture = player1_dead

# Signal handler for player 2's death
func _on_player2_dead() -> void:
	player2_texture.texture = player2_dead

# Signal handler for player 3's death
func _on_player3_dead() -> void:
	player3_texture.texture = player3_dead

# Signal handler for player 4's death
func _on_player4_dead() -> void:
	player4_texture.texture = player4_dead
