extends Sprite2D

@onready var animations = $duck




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animations.play("haaa")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AudioStreamPlayer2D.play()
	print("you win")
