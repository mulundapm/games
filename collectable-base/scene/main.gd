extends Node2D
var score
var lives
var objects : Array
var screen_size : Vector2i
var ground_height : int
const GRAVITY = 1500
const OBJECT_DELAY = 300
var game_running: bool

@export var object_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	score = 0
	lives = 3
	game_running = false
	$gameover.hide()

func _on_start_pressed() -> void:
	new_game()
	$StartScreen.hide()

func new_game():
	score = 0
	lives = 3
	game_running = true
	$CharacterBody2D.reset()
	$ScoreLabel.text = "Score : " + str(score)
	generate_object()
	$ObjectTimer.start()
	#Clear objects from previous rounds
	get_tree().call_group("objects", "queue_free")
	objects.clear()

#Use ObjectTimer node to generate object based on timer
func _on_object_timer_timeout():
	generate_object()
	
#Generating object falling from sky
func generate_object():
	var object = object_scene.instantiate()
	object.position.y = 0
	object.position.x = randi_range(150,1770)
	add_child(object)
	objects.append(object)
	object.collected.connect(scored)
	object.disappear.connect(loseLife)

#When restart button is clicked

func scored():
	score += 1
	$ScoreLabel.text = "Score : " + str(score)

func loseLife():
	if lives > 1: 
		lives -= 1
	elif lives == 1:
		lives -= 1
		stop_game()

func stop_game():
	$gameover.show()
	$ObjectTimer.stop()
	game_running = false

func _on_gameover_restart() -> void:
	new_game()
	$gameover.hide()
