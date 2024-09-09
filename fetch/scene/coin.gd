extends Area2D

signal genCoin
signal coinCollected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play()
	



func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D" and self.visible and get_parent().game_running == true:
		coinCollected.emit()
		$CoinTimer.start()
		hide()
	

func _on_coin_timer_timeout() -> void:
		queue_free()
		if get_parent().game_running == true:
			genCoin.emit()


#func _process(delta: float) -> void:
	## Ensure the heart icons are updated if the parent's lives change
	#update_lives(get_parent().lives)
#
#func update_lives(lives: int) -> void:
	## Iterate through all children (hearts) of the HBoxContainer
	#for i in range(get_child_count()):
		## Set each heart's visibility based on the player's remaining lives
		#get_child(i).visible = lives > i
