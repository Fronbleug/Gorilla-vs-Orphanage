extends GrabObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Hp = 100
export var MaxHp = 100
onready var DEffect = preload("res://scenes/Objects/Effect.tscn")
onready var Sound = preload("res://audio/gore.ogg")
onready var Sound2 = preload("res://audio/gore2.ogg")



# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	get_tree().root.get_node("Game").Children.append(self)
	Hp = MaxHp

func _physics_process(delta):
	if Velocity.length() > 10000:
			hurt(Hp)

func hurt(damage):

	Hp -= damage
	$TextureProgress.value = Hp
	
	if Hp <= 0:
		if Grabbed && Grabber != null:
			Grabber.GrabbedObject = null
			Grabber.HoverObject = null
			Grabber = null
		var Deffect = DEffect.instance()
		Deffect.position = position
		get_parent().add_child(Deffect)
		var SFX = global.SFX.instance()
		SFX.start(GetGoreSound())
		SFX.position = position
		get_parent().add_child(SFX)
		get_tree().root.get_node("Game").Children.remove(get_tree().root.get_node("Game").Children.find(self))
		queue_free()
func Collided(vel):
	.Collided(vel)
	hurt(vel.length()/50+Velocity.length()/50)
func GetGoreSound():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	match RNG.randi_range(0,1):
		0:
			return Sound
		1:
			return Sound2
	 
	
