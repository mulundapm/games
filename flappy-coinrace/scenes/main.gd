extends Node

@export var pipe_scene: PackedScene
@export var bukcoin_scene: PackedScene

var game_running: bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED :int = 8
var screen_size : Vector2i
var ground_height : int
var pipes: Array
var bukcoins: Array
const OBJECT_DELAY : int = 100
const OBJECT_RANGE : int = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game() # Replace with function body.

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "Score: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	get_tree().call_group("bukcoins", "queue_free")
	pipes.clear()
	bukcoins.clear()
	generate_pipes()
	generate_bukcoins()
	$Character.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Character.flying:
						$Character.flap()
						check_top()
						
func start_game():
	game_running = true
	$Character.flying = true
	$Character.flap()
	#start pipe timer
	$PipeTimer.start()
	$BukcoinTimer.start()
	
	
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		#reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		#move ground node
		$Ground.position.x = -scroll
		#move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
		for bukcoin in bukcoins:
			if is_instance_valid(bukcoin):
				bukcoin.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + OBJECT_DELAY
	pipe.position.y = (screen_size.y - ground_height) /2 + randi_range(-OBJECT_RANGE, OBJECT_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)


func _on_bukcoin_timer_timeout():
	generate_bukcoins()
	
func generate_bukcoins():
	var bukcoin = bukcoin_scene.instantiate()
	bukcoin.position.x = screen_size.x + OBJECT_DELAY *3
	bukcoin.position.y = (screen_size.y - ground_height) /2 + randi_range(-OBJECT_RANGE, OBJECT_RANGE)
	bukcoin.collectBuk.connect(scored)
	add_child(bukcoin)
	bukcoins.append(bukcoin)
	
func check_top():
	if $Character.position.y < 0:
		$Character.falling = true
		stop_game()
		
func stop_game():
	$PipeTimer.stop()
	$BukcoinTimer.stop()
	$Character.flying = false
	game_running = false
	game_over = true
	$GameOver.show()
	
func bird_hit():
	$Character.falling = true
	stop_game()

func _on_ground_hit():
	$Character.falling = false
	stop_game()
	
func scored():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)

func _on_game_over_restart():
	new_game()
	
	
