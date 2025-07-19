extends CharacterBody2D

@export var speed : float = 50
@export var damage : int = 1
@export var damage_cooldown : float = 1.0  # How often enemy can damage player

var player : Node2D
var can_attack : bool = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")

func _physics_process(delta):
	if player:
		# Move toward player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		# Check for player collision
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() == player and can_attack:
				attack_player()

func attack_player():
	player.take_damage(damage)
	can_attack = false
	await get_tree().create_timer(damage_cooldown).timeout
	can_attack = true

func _on_hit():  # Called when arrow hits
	queue_free()
