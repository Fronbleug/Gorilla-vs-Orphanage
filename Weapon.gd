class_name Weapon
extends GrabObject


func _ready():
	add_to_group("Weapon")

func _physics_process(delta):
	if Grabber != null:
		rotation = Grabber.Rotation
