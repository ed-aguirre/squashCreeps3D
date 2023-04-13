extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

#physics_process works similar to _process but for physics-related
func _physics_process(delta):
	#a local var to store the input direction
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		#in 3D the axis z means profundidad or ground plane
		direction.z -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
		
	#if the player press two directions at the same time...
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	
	#ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#vertical velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	#moving character
	velocity = target_velocity
	move_and_slide()

