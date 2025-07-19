extends Node2D

@export var enemy_scene : PackedScene
@export var spawn_rate : float = 6.0

func _ready():
	spawn_enemy()
	get_tree().create_timer(spawn_rate).timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_enemy()
	get_tree().create_timer(spawn_rate).timeout.connect(_on_timer_timeout)

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	# Spawn at random position 100 pixels from screen edges
	var viewport_size = get_viewport().get_visible_rect().size
	enemy.position = Vector2(randf_range(100, viewport_size.x - 100),randf_range(100, viewport_size.y - 100))
	call_deferred("add_child", enemy)
