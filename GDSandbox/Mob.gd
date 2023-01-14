extends KinematicBody

export var min_speed = 10
export var max_speed = 18

var velocity = Vector3.ZERO

func _physics_process(_delta):
	move_and_slide(velocity)

func initialize(start_position, player_position):
	# Aim towards player upon spawn
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))
	
	# Set random speed upon entering
	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# When exiting visible space, delete entity
func _on_VisibilityNotifier_screen_exited():
	queue_free()
