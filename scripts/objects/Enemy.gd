extends GrabObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Hp = 100
export var MaxHp = 100
onready var Sound = preload("res://audio/gore.ogg")
onready var Sound2 = preload("res://audio/gore2.ogg")

var WasCol = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	get_tree().root.get_node("Game").Children.append(self)
	Hp = MaxHp


func hurt(damage):

	Hp -= damage
	$TextureProgress.value = Hp
	
	if Hp <= 0:
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
		var index = get_tree().root.get_node("Game").Children.find(self)
		if index != -1:
			get_tree().root.get_node("Game").Children.remove(index)
		queue_free()
func Collided(vel,weight):
	.Collided(vel,weight)
	if weight == 0:
		weight = 0.000000000001
	hurt(((vel.length()/20)+Velocity.length()/2) / weight )
func GetGoreSound():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	match RNG.randi_range(0,1):
		0:
			return Sound
		1:
			return Sound2
	 
	
