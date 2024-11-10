class_name FadeToWhite
extends TextureRect

# fade to white
@export var fade_speed: float = 0.5
@export var image: TextureRect

var fade_in = false

func _process(delta):
	if fade_in:
		image.modulate.a += fade_speed * delta

func fade():
	fade_in = true