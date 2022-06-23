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

var Friction = 0.07

onready var HitSound = preload("res://audio/hit.ogg")

var TileOn = TILES.default

func _ready():
	add_to_group("GrabObject")

func _physics_process(delta):
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
			Velocity=PreColVel.bounce(get_slide_collision(0).normal)
	else:
		Velocity = (position - lastpos)/delta
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
		if body.is_in_group("GrabObjects"):
			Collided(body.PreColVel,body.Weight)
		elif body.is_in_group("Bullet"):
			print("d")
			body.queue_free()
			Collided(body.Velocity,1)
		elif body.is_in_group("Wall"):
			Collided(Vector2(),0.1)
		elif body.is_in_group("BreakObject"):
			body.Collided(Velocity,Weight)
		else:
			print("s")
			Collided(Vector2(),1)
func Collided(vel,weight):
	var SFX = global.SFX.instance()
	SFX.start(HitSound)
	SFX.position = position
	get_parent().add_child(SFX)
	Velocity += vel/weight * Weight


func _on_Area2D_area_entered(area):
	if area.owner.is_in_group("GrabObject") && area.owner != self:
		Collided(area.owner.PreColVel,area.owner.Weight)
