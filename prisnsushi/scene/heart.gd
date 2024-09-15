extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	# Ensure the heart icons are updated if the parent's lives change
	update_lives(get_parent().lives)

func update_lives(lives: int) -> void:
	# Iterate through all children (hearts) of the HBoxContainer
	for i in range(get_child_count()):
		# Set each heart's visibility based on the player's remaining lives
		get_child(i).visible = lives > i
