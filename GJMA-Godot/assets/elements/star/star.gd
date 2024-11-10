class_name Star
extends Area2D

# the collect sound
@export var music: MusicPlayer
@export var sound: AudioStreamPlayer2D
@export var fade_to_white: FadeToWhite


func _on_body_entered(body: Node2D) -> void:
	print("STAR Collided with " + str(body))
	if body is Player:
		sound.play()
		music.stop()
		fade_to_white.fade()

		get_tree().paused = true
		await get_tree().create_timer(7.5).timeout
		get_tree().paused = false
		
		Global.add_score_to_player(body.device_id)
	pass # Replace with function body.
