extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Level = null
var Player = null
var Bullets = null

var Time = 0.0

var Children = []

func _ready():
	load_level("res://scenes/levels/Test.tscn")
	Bullets = get_node("Bullets")

func _process(delta):
	if Children.size() <= 0:
		$CanvasLayer/Arrow.show()
	else:
		Time += delta
		$CanvasLayer/Label.text = str(stepify(Time,0.01))

func load_level(path):
	var level = load(path).instance()
	$Level.add_child(level)
	Level = $Level.get_child(0)
	$Player.position = Level.PlayerPos
	
