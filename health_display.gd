extends Label

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(update_display)
		update_display()

func update_display(new_health = null):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		text = "Health: %d" % player.current_health
