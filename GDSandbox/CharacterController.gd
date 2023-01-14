extends KinematicBody

export var speed = 14
export var gravity = 75
var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var dir = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_back"):
		dir.z += 1
	if Input.is_action_pressed("move_forward"):
		dir.z -= 1
		
	if dir != Vector3.ZERO:
		dir = dir.normalized()
		#$Pivot.look_at(translation + dir, Vector3.UP)
		
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	velocity.y = gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
		
