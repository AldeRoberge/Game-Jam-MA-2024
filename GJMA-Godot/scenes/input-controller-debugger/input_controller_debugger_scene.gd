extends Node2D

@export var next_scene: PackedScene

@onready var controls: Array[InputControllerDebugger] = [
	$Control,
	$Control2,
	$Control3,
	$Control4
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var readyCount: int = 0
	for i in range(controls.size()):
		if Input.get_connected_joypads().size() <= i:
			controls[i].hide()
		else:
			controls[i].show()
			if controls[i].state == "ready":
				readyCount += 1
		
	if readyCount == Input.get_connected_joypads().size() && readyCount != 0:
		get_tree().change_scene_to_packed(next_scene)
	pass
