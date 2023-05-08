extends GrabObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	
	$Icon.frame = global.RNG.randi_range(0,2)
	

func Collided(vel,weight):
	.Collided(vel,weight)
	var part = global.RockEffect.instance()
	part.position = position
	get_parent().add_child(part)
