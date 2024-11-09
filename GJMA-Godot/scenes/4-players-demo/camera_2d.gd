extends Camera2D


# A reference to the player #1
@export var player1: Player
@export var player2: Player
@export var player3: Player
@export var player4: Player


# Move the camera every frame to the highest player position. Dont move the horizontal axis.

func _process(delta: float) -> void:
	var highest_y = +INF  # Initialize to negative infinity
	if player1.position.y < highest_y:
		highest_y = player1.position.y
	if player2.position.y < highest_y:
		highest_y = player2.position.y
	if player3.position.y < highest_y:
		highest_y = player3.position.y
	if player4.position.y < highest_y:
		highest_y = player4.position.y
	
	#smoothly move the camera to the highest player position
	position.y = lerp(position.y, highest_y, 0.1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
