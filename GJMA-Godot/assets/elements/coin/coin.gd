class_name Coin
extends Area2D

var taken = false

func _on_body_enter(body):
	print("Collided with " + body )
	if not taken and body is Player:
		($AnimationPlayer as AnimationPlayer).play("taken")


# start
func _ready():
	# listen to area_entered
	body_entered.connect(_on_body_enter)
	pass
