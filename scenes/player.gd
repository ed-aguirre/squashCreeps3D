extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16
signal hit
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
	
	#jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		#is_on_floor() method is a tool from the CharacterBody3D class
		target_velocity.y = jump_impulse
	
	#loop
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		#collision with ground
		if (collision.get_collider() == null):
			continue
		
		#collision with a mob
		if (collision.get_collider().is_in_group("mob")):
			var mob = collision.get_collider()
			#hitting from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				#squash
				mob.squash()
				target_velocity.y = bounce_impulse

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
