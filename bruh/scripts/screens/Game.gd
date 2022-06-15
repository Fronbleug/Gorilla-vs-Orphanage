extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Level = null
var Player = null


func _ready():
	load_level("res://scenes/levels/Test.tscn")


func load_level(path):
	var level = load(path).instance()
	var children = $Level.get_children()
	for c in children:
		c.queue_free()
	$Level.add_child(level)
	Level = $Level.get_child(0)
	$Player.position = Level.PlayerPos
	
