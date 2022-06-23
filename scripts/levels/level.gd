extends Node2D


export var PlayerPos = Vector2(0,0)

export (NodePath) var Exit = null


func _ready():
	get_parent().get_parent().Door = get_node(Exit)
func _on_Teleport_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("GrabObject"):
		body.position = Vector2(1750,body.position.y)
func End(body):
	if get_parent().get_parent().Children.size() <= 0:
		if body.is_in_group("Player"):
		
			body.End()
			get_parent().get_parent().End()
		
