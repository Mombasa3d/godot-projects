extends KinematicBody

export var friction = 0.20
export var accel = 4
export var max_speed = 20
export var dash_speed = 40
var dash_velocity = Vector3.ZERO
var dash_dir = Vector3.ZERO
onready var dash_timer = get_node("DashTimer")
export var gravity = 150
export var jump_impulse = 20
var can_dash = true
var double_jump = true

enum States {GROUNDED, AIRBORNE, DASHING}

var _state : int = States.GROUNDED

var velocity = Vector3.ZERO

func _ready():
	dash_timer.connect("timeout", self, "dash_end")
	dash_timer.one_shot = true
	pass

func _physics_process(delta):
	var dir = Vector3.ZERO
	dir = movement_input(dir)	
	
	if dir != Vector3.ZERO and typeof(dir) == 7:
		dir = dir.normalized()
		$Pivot.look_at(translation + dir, Vector3.UP)
	
	# Acceleration and friction
	velocity.x += dir.x * accel if _state != 2 else dash_dir.x * accel
	velocity.x = clamp(lerp(velocity.x, 0, friction), -max_speed, max_speed)
	velocity.z += dir.z * accel if _state != 2 else dash_dir.z * accel
	velocity.z = clamp(lerp(velocity.z, 0, friction), -max_speed, max_speed)
	velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("dash") and dir != Vector3.ZERO and can_dash:
		_state = 2
		dash_velocity = velocity
		dash_timer.start()
		
	if _state == 2:
		can_dash = false		
		dash_dir = dir
#		dir = Vector3.ZERO
		var prev_state = _state
		velocity = Vector3(dash_dir.x * dash_speed, 0 , dash_dir.z * dash_speed)
#		if dash_timer >= dash_time_limit:
#			_state = prev_state
#			velocity = dash_velocity
#			dash_timer = 0
	
	if is_on_floor():
		if !can_dash:
			can_dash = true
		else:
			_state = 0
	
	if _state == 0 and !double_jump:
		double_jump = true
	if _state == 0 and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
		_state = 1
	elif _state == 1 and Input.is_action_just_pressed("jump") and double_jump:
		velocity.y = 0
		velocity.y += jump_impulse
		double_jump = false
		
	velocity = move_and_slide(velocity, Vector3.UP)

func dash_end():
	_state = 1
	

func movement_input(dir):
	if _state == 2:
		return dash_dir
	if Input.is_action_pressed("move_right") and _state != 2:
		dir.x += 1
	if Input.is_action_pressed("move_left") and _state != 2:
		dir.x -= 1
	if Input.is_action_pressed("move_back") and _state != 2:
		dir.z += 1
	if Input.is_action_pressed("move_forward") and _state != 2:
		dir.z -= 1
	return dir if dir != Vector3.ZERO else Vector3.ZERO
