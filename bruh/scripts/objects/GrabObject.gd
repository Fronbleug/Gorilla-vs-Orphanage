class_name GrabObject
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var Weight = 0.1
var Velocity = Vector2()
var Grabbed = false
var lastpos = Vector2()
var PreColVel = Vector2()
var Grabber = null

func _ready():
	add_to_group("GrabObject")

func _physics_process(delta):
	
	PreColVel = Velocity
	if not Grabbed:
		Velocity = lerp(Velocity,Vector2(), 0.05)
		Velocity = move_and_slide(Velocity)

	else:
		Velocity = (position - lastpos)/delta
	lastpos = position
func UnGrab():
	Grabbed = false
	Grabber = null
func Grab(e):
	Grabber = e
	Grabbed = true


func _on_Area2D_body_entered(body):
	if body != self:
		if is_in_group("GrabObjects"):
			Collided(body.PreColVel)
		else:
			Collided(Vector2())
func Collided(vel):
	Velocity += vel


func _on_Area2D_area_entered(area):
	if area.owner.is_in_group("GrabObject") && area.owner != self:
		print("d")
		Collided(area.owner.PreColVel)
