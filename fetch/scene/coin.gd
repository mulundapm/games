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
	if body.name == "CharacterBody2D" and self.visible:
		coinCollected.emit()
		$CoinTimer.start()
		hide()
	

func _on_coin_timer_timeout() -> void:
		genCoin.emit()
		queue_free()
