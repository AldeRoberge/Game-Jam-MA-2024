extends Node2D

@export var next_scene: PackedScene

@onready var controls := [
	$Control as InputControllerDebugger,
	$Control2 as InputControllerDebugger,
	$Control3 as InputControllerDebugger,
	$Control4 as InputControllerDebugger
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var readyCount: int = 0
	for control: InputControllerDebugger in controls:
		if control.state == "ready":
			readyCount += 1
	if readyCount == 4:
		get_tree().change_scene_to_packed(next_scene)
	pass
