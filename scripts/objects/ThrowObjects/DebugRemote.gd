extends Remote

var Ammo = 0

func Use():
	emit_signal("use",Ammo)
