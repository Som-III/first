extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree

@export var SPEED : float = 80
@export var SPRINT_SPEED : float = 300  # Add this new export variable for sprint speed
@export var ACCELERATION : float = 100  # Optional: for smoother speed transitions
@export var max_health : int = 3


@onready var spawnpos : Node2D = $Node2D

var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2.RIGHT  # Default to facing right
var arrow_scene=load("res://arrow.tscn")
var current_speed : float = SPEED 
var current_health : int = max_health

func _ready() -> void:
	animation_tree.active = true

func _process(delta: float) -> void:
	update_statemachines()

func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("sprint"):
		current_speed = SPRINT_SPEED
	else:
		current_speed = SPEED
		
	
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	if direction != Vector2.ZERO:
		last_direction = direction
		
	if direction:
		velocity = direction * current_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func update_statemachines():
	animation_tree.set("parameters/conditions/isIdle",velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/isMove",velocity != Vector2.ZERO)
	animation_tree.set("parameters/conditions/isAttack",Input.is_action_just_pressed("attack"))
	if(Input.is_action_just_pressed("attack")):
		fire()
	
	if(direction != Vector2.ZERO):
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/move/blend_position"] = direction
		animation_tree["parameters/attack/blend_position"] = direction
		

func fire():
	
	await get_tree().create_timer(0.4).timeout
	var arrow = arrow_scene.instantiate()
	arrow.spawnpos = spawnpos.global_position
	arrow.direction = last_direction.normalized()  # Use last_direction instead of direction
	get_parent().add_child.call_deferred(arrow)
	
signal health_changed(new_health)
# Add this new function to handle damage
func take_damage(amount: int = 1):
	current_health -= amount
	emit_signal("health_changed", current_health)  # Simple debug output
	if current_health <= 0:
		queue_free()  # Or add your game over logic
