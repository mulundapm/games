extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -1200.0
const START_POSITION = Vector2(100,100)
const GRAVITY = 1500

func _ready():
	pass

func reset():
	position = START_POSITION
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	move_and_slide()
