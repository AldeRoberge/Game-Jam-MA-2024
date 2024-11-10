class_name Coin 
extends Area2D

var taken = false

func _on_body_enter(body):
	print("COIN Collided with " + str(body))
	if not taken and body is Player:
		body = body as Player
		taken = true
		($AnimationPlayer as AnimationPlayer).play("taken")
		Global.add_score_to_player(body.device_id, Global.COIN_SCORE)
