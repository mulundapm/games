extends Area2D
var DROP_SPEED = randi_range(5,10)

signal collected
signal disappear
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if is_instance_valid(Area2D):
		if not is_on_floor_or_platform():
			position.y += DROP_SPEED
			
func is_on_floor_or_platform():
	for body in get_overlapping_bodies():
		if body.name == "platform" or "Floor":
			return true
	
func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		collected.emit()
		queue_free()
	if is_on_floor_or_platform():
		$DisappearTimer.start()
	

func _on_disappear_timer_timeout() -> void:
	disappear.emit()
	queue_free()
