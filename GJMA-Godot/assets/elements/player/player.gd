class_name Player
extends RigidBody2D

const WALK_ACCEL = 1000.0
const WALK_DEACCEL = 1000.0
const WALK_MAX_VELOCITY = 200.0
const AIR_ACCEL = 800.0
const AIR_DEACCEL = 800.0
const JUMP_VELOCITY = 320.0
const STOP_JUMP_FORCE = 450.0
const MAX_SHOOT_POSE_TIME = 0.3
const MAX_FLOOR_AIRBORNE_TIME = 0.15

#const BULLET_SCENE = preload("res://player/bullet.tscn")
#const ENEMY_SCENE = preload("res://enemy/enemy.tscn")


# Allow to select the player device id (int) in the editor.
@export var device_id := 0

var anim := ""
var siding_left := false
var jumping := false
var can_double_jump := false
var stopping_jump := false
var old_jump = null

var floor_h_velocity: float = 0.0

var airborne_time: float = 1e20

var _is_dead: bool = false

signal signal_on_death

@onready var sound_jump := $"Sound Jump" as AudioStreamPlayer2D
@onready var sound_death := $"Sound Death" as AudioStreamPlayer2D
@onready var sound_shoot := $"Sound Shoot" as AudioStreamPlayer2D

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var sprite_smoke := sprite.get_node(^"Smoke") as CPUParticles2D

func _ready() -> void:
	if Input.get_connected_joypads().size() <= device_id:
		for children in get_children():
			children.queue_free()
		queue_free()

func _do_jump(velocity: Vector2) -> Vector2:
	velocity.y = -JUMP_VELOCITY
	jumping = true
	stopping_jump = false
	sound_jump.play()
	return velocity


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity := state.get_linear_velocity()
	var step := state.get_step()

	var new_anim := anim
	var new_siding_left := siding_left

	# Get player input.
	var move_left := _get_input_dpad_left() or _get_input_joy_left().x < -0.5
	var move_right := _get_input_dpad_right() or _get_input_joy_left().x > 0.5
	var jump := _get_input_jump()
	var spawn := _get_input_spawn()

#	if spawn:
#		_spawn_enemy_above.call_deferred()

	# Deapply prev floor velocity.
	velocity.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor (a contact with upwards facing collision normal).
	var found_floor := false
	var floor_index := -1

	for contact_index in state.get_contact_count():
		var collision_normal = state.get_contact_local_normal(contact_index)

		if collision_normal.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = contact_index

	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air.

	var on_floor := airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump.
	if jumping:
		if velocity.y > 0:
			# Set off the jumping flag if going down.
			jumping = false
		elif not jump:
			stopping_jump = true

		if stopping_jump:
			velocity.y += STOP_JUMP_FORCE * step

	if on_floor:
		# Process logic when character is on floor.
		if move_left and not move_right:
			if velocity.x > -WALK_MAX_VELOCITY:
				velocity.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if velocity.x < WALK_MAX_VELOCITY:
				velocity.x += WALK_ACCEL * step
		else:
			var xv := absf(velocity.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			velocity.x = signf(velocity.x) * xv

		# Check jump.
		if not jumping and jump and old_jump != jump:
			can_double_jump = true
			velocity = _do_jump(velocity)

		# Check siding.
		if velocity.x < 0 and move_left:
			new_siding_left = true
		elif velocity.x > 0 and move_right:
			new_siding_left = false
		if absf(velocity.x) < 0.1:
			new_anim = _get_player_id() + "idle"
		else:
			new_anim = _get_player_id() + "walk"
	else:
		# Check double jump
		if can_double_jump and jump and old_jump != jump:
			can_double_jump = false
			velocity = _do_jump(velocity)
		
		# Process logic when the character is in the air.
		if move_left and not move_right:
			if velocity.x > -WALK_MAX_VELOCITY:
				velocity.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if velocity.x < WALK_MAX_VELOCITY:
				velocity.x += AIR_ACCEL * step
		else:
			var xv := absf(velocity.x)
			xv -= AIR_DEACCEL * step

			if xv < 0:
				xv = 0
			velocity.x = signf(velocity.x) * xv

		if velocity.y > 0:
			new_anim = _get_player_id() + "fall"
		elif velocity.y < 0:
			new_anim = _get_player_id() + "idle"

	# Update siding.
	if new_siding_left != siding_left:
		if new_siding_left:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1

		siding_left = new_siding_left

	# Change animation.
	if new_anim != anim:
		anim = new_anim
		sprite.play(anim)

	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = state.get_contact_collider_velocity_at_position(floor_index).x
		velocity.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity.
	velocity += state.get_total_gravity() * step
	state.set_linear_velocity(velocity)
	
	old_jump = jump


#func _spawn_enemy_above() -> void:
#	var enemy := ENEMY_SCENE.instantiate() as RigidBody2D
#	enemy.position = position + 50 * Vector2.UP
#	get_parent().add_child(enemy)


######################## PLAYER ID LOGIC ########################

func _get_player_id() -> String:
	if device_id == 0:
		return "p1_"
	elif device_id == 1:
		return "p2_"
	elif device_id == 2:
		return "p3_"
	elif device_id == 3:
		return "p4_"
	else:
		return "p1_"

######################### HANDLE PLAYER INPUT LOGIC #########################

# debug button (spawn enemy) is the left bumper
func _get_input_spawn() -> bool: return Input.is_joy_button_pressed(device_id, JOY_BUTTON_LEFT_SHOULDER)

func _get_input_dpad_left() -> bool: return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_LEFT)
func _get_input_dpad_right() -> bool: return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_RIGHT)
func _get_input_dpad_up() -> bool: return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_UP)
func _get_input_dpad_down() -> bool: return Input.is_joy_button_pressed(device_id, JOY_BUTTON_DPAD_DOWN)

# get the joystick input
func _get_input_joy_left() -> Vector2:
	return Vector2(Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X), Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y))

# kills the player
func _kill_player() -> void:
	# Log the player's death.
	print("Player " + str(device_id + 1) + " has died.")
	sound_death.play()
	_is_dead = true
	signal_on_death.emit()
	#for children in get_children():
	#	children.queue_free()
	#queue_free()

# Get the jump input (any face button)
func _get_input_jump() -> bool:
	return Input.is_joy_button_pressed(device_id, JOY_BUTTON_X) or \
		   Input.is_joy_button_pressed(device_id, JOY_BUTTON_Y) or \
		   Input.is_joy_button_pressed(device_id, JOY_BUTTON_B) or \
		   Input.is_joy_button_pressed(device_id, JOY_BUTTON_A)


####################### END PLAYER INPUT LOGIC ##############################
