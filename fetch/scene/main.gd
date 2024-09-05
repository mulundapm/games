extends Node2D
var score
var lives
var objects : Array
var coins : Array
var screen_size : Vector2i
var ground_height : int
const GRAVITY = 1500
const OBJECT_DELAY = 300

@export var object_scene: PackedScene
@export var coin_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	#ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	score = 0
	lives = 3
	$ScoreLabel.text = "Score : " + str(score)
	$LifeCounter.text = "Lives left : " + str(lives)
	$CharacterBody2D.reset()
	generate_object()
	generate_coin()
	$ObjectTimer.start
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

#Generating object falling from sky
func generate_object():
	var object = object_scene.instantiate()
	object.position.y = 0
	object.position.x = randi_range(150,1770)
	add_child(object)
	objects.append(object)
	object.collected.connect(scored)
	object.disappear.connect(loseLife)

func _on_object_timer_timeout():
	generate_object()

func _on_gameover_restart() -> void:
	new_game()

	
func scored():
	score += 1
	$ScoreLabel.text = "Score : " + str(score)

func earnLife():
	if lives < 3:
		lives += 1
		$LifeCounter.text = "Lives left : " + str(lives)

func loseLife():
	if lives > 0:
		lives -= 1
		$LifeCounter.text = "Lives left : " + str(lives)

func generate_coin():
	var coin = coin_scene.instantiate()
	add_child(coin)
	coins.append(coin)
	coin.genCoin.connect(generate_coin)
	coin.coinCollected.connect(earnLife)

	
