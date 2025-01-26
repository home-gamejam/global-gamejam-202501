@tool
extends CharacterBody3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)
@onready var _camera := %Camera3D as Camera3D
@onready var _camera_pivot := %CameraPivot as Node3D
@onready var _animation_tree = %AnimationTree as AnimationTree
@onready var _character = %Character as Node3D

const ACCELERATION = 20.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = TAU * 2

var is_running = false
var last_direction := Vector3.BACK
var speed = SPEED

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	is_running = Input.is_action_pressed("run")
		
	if is_running:
		speed = SPEED * 2
	else:
		speed = SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	## Original character controller code
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * speed
		#velocity.z = direction.z * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
		
	## My code
	#var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
		#
	#if direction.length() > 0.2:
		#last_direction = direction
		#
	#var target_angle = Vector3.BACK.signed_angle_to(last_direction, Vector3.UP)
	#rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
#
	## Temporarily remove y velocity from move_toward calculation
	#var vel_y = velocity.y
	#velocity.y = 0.0
	#velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
	#velocity.y = vel_y
	
	## Tutorial
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var direction := forward * input_dir.y + right * input_dir.x
	if direction.length() > 0:
		direction.y = 0.0
		direction = direction.normalized()
		velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)

	move_and_slide()
	
	if direction.length() > 0.2:
		last_direction = direction
		
	var target_angle := Vector3.BACK.signed_angle_to(last_direction, Vector3.UP)
	_character.global_rotation.y = lerp_angle(_character.rotation.y, target_angle, ROTATION_SPEED * delta)
	
	# blend_position is 0, 1, 2 for idle, walk, run respectively. Multiplying
	# walk or run by the input_dir magnitude should hit the values exactly when
	# value is 1 and a blend when it is < 1
	var blend_position =  (2 if is_running else 1) * input_dir.length()
	_animation_tree.set("parameters/Movement/blend_position", blend_position)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
