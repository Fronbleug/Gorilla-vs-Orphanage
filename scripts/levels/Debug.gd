extends Level

onready var Orphan = preload("res://scenes/objects/Child.tscn")

func _on_Remote_use(e):
	var d = Orphan.instance()
	d.position = get_global_mouse_position()
	$YSort.add_child(d)
