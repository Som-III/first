extends CharacterBody2D

var spawnpos : Vector2
var direction : Vector2 = Vector2.ZERO  # Add a direction variable
var speed : float = 200  # Define arrow speed
var lifetime : float = 2.0  # Define arrow lifetime

func _ready() -> void:
	global_position = spawnpos
	global_rotation = direction.angle()  # Rotate the arrow to face the direction
	call_deferred("_destroy_after_time")

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider and collider.is_in_group("enemies"):
			collider.queue_free()  # Immediately destroy enemy
			queue_free()  # Destroy arrow

func _destroy_after_time() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
