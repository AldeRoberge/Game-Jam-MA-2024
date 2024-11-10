class_name Coin 
extends Area2D

var taken = false

func _on_body_enter(body):
	print("COIN Collided with " + str(body))
	if not taken and body is Player:
		# call the collect coin method on the player
		body.collect_coin()
		($AnimationPlayer as AnimationPlayer).play("taken")
