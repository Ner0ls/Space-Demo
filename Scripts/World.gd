extends Node

const Rock = preload("res://Scenes/Rock.tscn")
export (PackedScene) var LRock
export (PackedScene) var EShip
var score
var level
var game_timers 
var active_enemies

func _ready():
	randomize()


func newGame():
	clearEnemies()
	level = 1
	score = 0
	game_timers = []
	active_enemies = {}
	$Player.start($StartPos.position)
	$StartTimer.start()
	$Interface.showLevelUp(level)
	$Interface.showMessage("READY")
	$Interface.updateScore(score)


func _on_Player_hit():
	for timer in game_timers:
		timer.stop()

	print_debug(active_enemies)
	for enemy in active_enemies:
		if active_enemies[enemy].has("instances"):
			for instance in active_enemies[enemy].instances:
				if instance != null:
					instance.disconnect("out_of_screen", self, "clearActiveEnemyInstance")
					instance.set_collision_layer_bit(1, false)
	
	$Interface.gameOver() # Game over


func _on_StartTimer_timeout():
	game_timers.append($RockTimer) # Iniciar timer de rocas para generacion.
	game_timers.append($ScoreTimer)
	game_timers.append($LevelUpTimer)
	
	for timer in game_timers:
		timer.start()
	
	$Interface/ScoreLabel.show()


func _on_ScoreTimer_timeout():
	score += 1
	$Interface.updateScore(score)


func _on_RockTimer_timeout():
	# Seleccionar un punto random en EnemyPath para que la roca salga
	$EnemyPath/RockPath.set_offset(randi())
	
	var rock = Rock.instance()
	if (!active_enemies.has("Rocks")):
		active_enemies.Rocks = {}
		
	if !active_enemies.Rocks.has("instances"):
		active_enemies.Rocks.instances = []
	
	active_enemies.Rocks.instances.append(rock)
	rock.connect("out_of_screen", self, "clearActiveEnemyInstance")
	add_child(rock)
	
	# Seleccionar una direccion (angulo)
	var rockRotation = $EnemyPath/RockPath.rotation_degrees + 90
	
	rock.position = $EnemyPath/RockPath.position
	rockRotation += rand_range(-45, 45)
#	rock.rotation_degrees = rockRotation
	rock.set_linear_velocity(Vector2(rand_range(rock.minVelocity, rock.maxVelocity), 0).rotated(deg2rad(rockRotation)))


func _on_LRockTimer_timeout():
	# Seleccionar un punto random en EnemyPath para que la roca salga
	$EnemyPath/RockPath.set_offset(randi())
	
	var rock = LRock.instance()
	if (!active_enemies.has("LRocks")):
		active_enemies.LRocks = {}
		
	if !active_enemies.LRocks.has("instances"):
		active_enemies.LRocks.instances = []
	
	active_enemies.LRocks.instances.append(rock)
	rock.connect("out_of_screen", self, "clearActiveEnemyInstance")
	add_child(rock)
	
	# Seleccionar una direccion (angulo)
	var rockRotation = $EnemyPath/RockPath.rotation_degrees + 90
	
	rock.position = $EnemyPath/RockPath.position
	rockRotation += rand_range(-45, 45)
#	rock.rotation_degrees = rockRotation
	rock.set_linear_velocity(Vector2(rand_range(rock.minVelocity, rock.maxVelocity), 0).rotated(deg2rad(rockRotation)))


func _on_LevelUpTimer_timeout():
	level += 1 # Level Up

	match level: # 60 secs generate BIGGER ROCK
#		2:
#			Rock.minVelocity = 175
#			Rock.maxVelocity = 325
		3:
			$LRockTimer.start()
			game_timers.append($LRockTimer)
	
	

	$Interface.showLevelUp(level)


func clearActiveEnemyInstance(instance, group):
	active_enemies[group]["instances"].erase(instance)


func clearEnemies():
	if active_enemies != null && active_enemies.size() > 0:
		for enemy in active_enemies:
			if active_enemies[enemy].has("instances"):
				for instance in active_enemies[enemy].instances:
					if instance != null:
						instance.queue_free()
