extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_area_2d_body_entered(body: Node2D) -> void:
	print("lalala")

func _physics_process(delta: float) -> void:
	velocity.x = 10
	velocity.y = 5
	move_and_slide()
	
