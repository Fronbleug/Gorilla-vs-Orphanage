class_name GrabObject
extends KinematicBody2D


enum TILES {default, ice}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var Weight = 0.1
var Velocity = Vector2()
var Grabbed = false
var lastpos = Vector2()
var PreColVel = Vector2()
var Grabber = null
var Delta = 0

export var Piercing = false

export var Damage = 1

var Friction = 0.07

onready var HitSound = preload("res://audio/hit.ogg")

var TileOn = TILES.default

var Col = null

func _ready():
	add_to_group("GrabObject")

func _physics_process(delta):
	Delta = delta
	var tile = get_tree().root.get_node("Game").Tilemap.get_cellv((position/64).round())
	TileOn = get_tree().root.get_node("Game").Tilemap.GetTileType(tile)
	
	
	match TileOn:
		TILES.default:
			Friction = 0.07
		TILES.ice:
			Friction = 0
	PreColVel = Velocity
	if not Grabbed:
		Velocity = lerp(Velocity,Vector2(), Friction)
		Velocity = move_and_slide(Velocity)
		if get_slide_count() > 0:
			if not Piercing:
				Velocity=PreColVel.bounce(get_slide_collision(0).normal)
			else:
				Velocity=PreColVel
	else:
		Velocity = ((position - lastpos)/delta) - (Grabber.Velocity/1.15)
	lastpos = position
func UnGrab():
	z_index = 0
	Grabbed = false
	Grabber = null
func Grab(e):
	z_index = -1
	Grabber = e
	Grabbed = true


func _on_Area2D_body_entered(body):
	if body != self:
		if body.is_in_group("GrabObject"):
			Collided(body.PreColVel*Delta,body.Weight,body.Damage)
		if body.is_in_group("Bullet"):
			print("d")
			body.queue_free()
			Collided(body.Velocity/Delta,1,body.Damage)
		elif body.is_in_group("Wall"):
			Collided(Vector2(),2,1)
			if Piercing:
				Velocity = Vector2()
		elif body.is_in_group("BreakObject"):
			body.Collided(Velocity,Weight,1)
		else:
			print("s")
			Collided(Vector2(),1,0)
func Collided(vel,weight,dam):
	var SFX = global.SFX.instance()
	SFX.start(HitSound)
	SFX.position = position
	get_parent().add_child(SFX)
	Velocity += vel/weight * Weight

func _on_Area2D_area_entered(area):
	if area.owner.is_in_group("GrabObject") && area.owner != self:
		Collided(area.owner.PreColVel,area.owner.Weight,area.owner.Damage)

func Use():
	pass
func UnUse():
	pass
	
func Flip(flip):
	if flip:
		scale.y =-1
	else:
		scale.y = 1 
	
