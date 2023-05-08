class_name LivingGrabObject
extends GrabObject


onready var Sound = preload("res://audio/gore.ogg")
onready var Sound2 = preload("res://audio/gore2.ogg")






func Die():
		if Grabbed && Grabber != null:
			Grabber.GrabbedObject = null
			Grabber.HoverObject = null
			Grabber = null
		var Deffect = global.BloodEffect.instance()
		Deffect.position = position
		get_parent().call_deferred("add_child",Deffect)
		var SFX = global.SFX.instance()
		SFX.start(GetGoreSound())
		SFX.position = position
		get_parent().add_child(SFX)
		
		queue_free()
func GetGoreSound():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	match RNG.randi_range(0,1):
		0:
			return Sound
		1:
			return Sound2
	 
