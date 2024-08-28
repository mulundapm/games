extends Area2D

signal collectBuk

#var cointurn : bool = true

func _on_body_entered(body):
	if body.name == "Character":
		collectBuk.emit()
		queue_free()

func _physics_process(delta):
	$AnimatedSprite2D.play()
