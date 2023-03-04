extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Level = null
var Player = null
var Bullets = null
var Tilemap = null

var LevelTimer = 0.0

var Children = []
var Ended = false

var Door = null

onready var Enemy = preload("res://scenes/objects/ThrowObjects/LivingObjects/Enemy.tscn")

func _ready():
	load_level(global.Levels[global.CurLevel])
	Bullets = get_node("Bullets")
func _process(delta):
	
	if Children.size() <= 0:
		$CanvasLayer/Arrow.show()
		if Player != null && Door != null:
			$CanvasLayer/Arrow.set_rotation( ((Player.position - Door.position).normalized()).angle())
	if not Ended:
			LevelTimer += delta
			$CanvasLayer/Label.text = str(stepify(LevelTimer,0.01))
	$CanvasLayer/Label2.text = str("Orphans Remaining: ", Children.size())
func SpawnCops():
	for i in range():
		var e = Enemy.instance()
		Level.get_node("YSort").add_child(e)
		yield(get_tree().create_timer(0.3),"timeout")
func load_level(path):
	var level = load(path).instance()
	$Level.add_child(level)
	Level = $Level.get_child(0)
	
func End():
	$AnimationPlayer.play("End")
	Ended = true
	$CanvasLayer/EndPanel2/Label.text = str(stepify(LevelTimer,0.01))

func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/screens/MainMenu.tscn")


func _on_Exit2_pressed():
	get_tree().quit()


func _on_NextLevel_pressed():
	var e = $Level.get_children()
	for i in e:
		i.queue_free()
	global.CurLevel += 1
	load_level(global.Levels[global.CurLevel])
	if global.Levels.size() >= global.CurLevel + 1:
		$CanvasLayer/EndPanel2/VBoxContainer/NextLevel.hide()
	$CanvasLayer/EndPanel2.hide()
	$CanvasLayer/Arrow.hide()
	Ended = false
	LevelTimer = 0
