extends CharacterBody3D

#min and max velocity in meter per second
@export var min_speed = 10
@export var max_speed = 18
signal squashed

#physics_process works as process but with physics objects
func _physics_process(delta):
	move_and_slide()

#func will be called from main
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI/4, PI/4))
	
	#calculated the speed in integer
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	

func squash():
	squashed.emit()
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free() #This function destroy the instance it's called on.
