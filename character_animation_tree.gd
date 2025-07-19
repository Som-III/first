extends Node2D

@export var animation_tree: AnimationTree
@onready var player : CharacterBody2D = get_owner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	animation_tree.set("parameters/idle/blend_position",player.velocity.normalized())
	animation_tree.set("parameters/move/blend_position",player.velocity.normalized())
	animation_tree.set("parameters/attack/blend_position",player.velocity.normalized())
