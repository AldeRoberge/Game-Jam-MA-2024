class_name Star
extends Area2D

# the collect sound
@export var music: MusicPlayer
@export var sound: AudioStreamPlayer2D
@export var fade_to_white: FadeToWhite



func _on_body_entered(body: Node2D) -> void:
	print("STAR Collided with " + str(body))
	if body is Player:
		print("2222222222222")
		#($AnimationPlayer as AnimationPlayer).play("taken")
		sound.play()
		music.stop()
		fade_to_white.fade()
		
		# pause game
		get_tree().paused = true
	pass # Replace with function body.
