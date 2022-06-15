extends GrabObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Hp = 100
export var MaxHp = 100
onready var DEffect = preload("res://scenes/Objects/Effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	Hp = MaxHp

func _physics_process(delta):
	print(Velocity)
	if Velocity.length() > 10000:
			hurt(Hp)

func hurt(damage):

	Hp -= damage
	print(":<")
	$TextureProgress.value = Hp
	if Hp <= 0:
		if Grabbed && Grabber != null:
			Grabber.GrabbedObject = null
			Grabber.HoverObject = null
			Grabber = null
		var Deffect = DEffect.instance()
		Deffect.position = position
		get_parent().add_child(Deffect)
		queue_free()
func Collided(vel):
	.Collided(vel)
	hurt(vel.length()/5+Velocity.length()/5)
