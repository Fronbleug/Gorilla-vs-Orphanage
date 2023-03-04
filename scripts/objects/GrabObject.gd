class_name GrabObject
extends KinematicBody2D


enum TILES {default, ice}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var Mass = 1
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
		Move()
		if Piercing:
			if Velocity != Vector2():
				rotation = Velocity.angle()
		
		if get_slide_count() > 0:
			if Piercing:
				Velocity=PreColVel
	else:
		if Grabber != null:
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

func Move():
	Velocity = lerp(Velocity,Vector2(), Friction)
	Velocity = move_and_slide(Velocity)

func _on_Area2D_body_entered(body):
	if body != self:
		if body.is_in_group("Bullet"):
			body.queue_free()
			Collided(body.Velocity, body.Mass)
		elif body.is_in_group("Wall"):
			Collided(Vector2(), 20)
			if Piercing:
				Velocity = Vector2()
		elif body.is_in_group("BreakObject"):
			body.Collided(Velocity,Mass)
		else:
			Collided(Vector2(),1)
func Collided(vel,mass):
	var SFX = global.SFX.instance()
	SFX.start(HitSound)
	SFX.position = position
	get_parent().add_child(SFX)
	#calculate Velocity
	var VF = Vector2()
	var MT = 0
	MT = mass + Mass
	VF = ( vel*mass - Velocity*Mass )/MT
	print(str(self," ", VF))
	Velocity = VF

func _on_Area2D_area_entered(area):
	if area.owner.is_in_group("GrabObject") && area.owner != self:
		Collided(area.owner.PreColVel,area.owner.Mass)

func Use():
	pass
func UnUse():
	pass
	
func Flip(flip):
	if flip:
		scale.y =-1
	else:
		scale.y = 1 
	
