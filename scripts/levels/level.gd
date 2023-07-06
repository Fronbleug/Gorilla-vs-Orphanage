class_name Level
extends Node2D




export var PlayerPos = Vector2(0,0)

export (NodePath) var Exit = null

export var Music = preload("res://audio/MainMenu.wav")

func _ready():
	get_parent().get_parent().Door = get_node(Exit)
	if audio.stream != Music:
		audio.stream = Music
		audio.play()
func ShakeCam(am:float):
	$YSort/Player.ShakeMag += am 
func _on_Teleport_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("GrabObject"):
		body.position = Vector2(1750,body.position.y)
func End(body):
	if get_parent().get_parent().Children.size() <= 0:
		if body.is_in_group("Player"):
		
			body.End()
			get_parent().get_parent().End()
		



