extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Level = null
var Player = null
var Bullets = null
var Tilemap = null

var Time = 0.0

var Children = []
var Ended = false

var Door = null

func _ready():
	load_level(global.Level)
	Bullets = get_node("Bullets")

func _process(delta):
	
	if Children.size() <= 0:
		$CanvasLayer/Arrow.show()
		if Player != null && Door != null:
			$CanvasLayer/Arrow.set_rotation( ((Player.position - Door.position).normalized()).angle())
	if not Ended:
			Time += delta
			$CanvasLayer/Label.text = str(stepify(Time,0.01))
	$CanvasLayer/Label2.text = str("Orphans Remaining: ", Children.size())

func load_level(path):
	var level = load(path).instance()
	$Level.add_child(level)
	Level = $Level.get_child(0)
	
func End():
	$AnimationPlayer.play("End")
	Ended = true
	$CanvasLayer/EndPanel2/Label.text = str(stepify(Time,0.01))

func _on_Exit_pressed():
	get_tree().change_scene("res://scenes/screens/MainMenu.tscn")


func _on_Exit2_pressed():
	get_tree().quit()
