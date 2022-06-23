extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var MaxHp = 200
export var Hp = 200
onready var Particle = preload("res://scenes/objects/effects/Wood.tscn")

onready var HitSound = preload("res://audio/hit.ogg")

func _ready():
	Hp = MaxHp
	$Sprite/Break.hide()

func Collided(vel,w):
	var SFX = global.SFX.instance()
	SFX.start(HitSound)
	SFX.position = position
	get_parent().add_child(SFX)
	Hp -= (vel.length()/10)/w
	GetBreakAmmount(Hp)
	if Hp <= 0:
		var part = Particle.instance()
		part.position = position
		get_parent().add_child(part)
		
		queue_free()

func GetBreakAmmount(dam):
	var factor = MaxHp/100
	if Hp >= 100*factor:
		$Sprite/Break.hide()
	else:
		$Sprite/Break.show()
	if Hp<75*factor:
		$Sprite/Break.frame = 1
	if Hp<50*factor:
		$Sprite/Break.frame = 2
	if Hp<25*factor:
		$Sprite/Break.frame = 3
