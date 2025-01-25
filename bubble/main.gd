extends Node2D

var bubble = preload("res://bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("bubble"):
		var bubble_spawner = bubble.instantiate()
		add_child(bubble_spawner)
