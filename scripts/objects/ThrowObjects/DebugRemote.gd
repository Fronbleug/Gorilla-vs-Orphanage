extends Remote

var Ammo = 0


func Use():
	emit_signal("use",Ammo)
	var thing = global.Objects[Ammo].instance()
	thing.position = get_global_mouse_position()
	get_parent().add_child(thing)
	
func _input(event):
	if event.is_action_pressed("ScrollUp"):
		Ammo += 1
	if event.is_action_pressed("ScrollDown"):
		Ammo -= 1
