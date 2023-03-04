class_name PathFinder
extends LivingGrabObject

export var WalkSpeed = 32
export var TargetLocation = Vector2()

onready var NavAgent = $NavigationAgent2D


var CanPath = true
var Pathing = true
var AtLocation = false
func _ready():
	pass

func SetTargetLocation(loc):
	TargetLocation = loc
	NavAgent.set_target_location(loc)
func _physics_process(delta):
	Velocity = lerp(Velocity,Vector2(), Friction)
	if CanPath:
		if Pathing:
			
			var moveDir = position.direction_to(NavAgent.get_next_location())
			Velocity += moveDir * WalkSpeed
			NavAgent.set_velocity(Velocity)

func Move():
	if not Pathing:
		.Move()

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if not AtLocation:
		Velocity = move_and_slide(safe_velocity)


func _on_NavigationAgent2D_target_reached():
	Pathing = false





func _on_StunTimer_timeout():
	Pathing = true
func UnGrab():
	.UnGrab()
	$StunTimer.start()
func Grab(e):
	.Grab(e)
	Pathing = false
	$StunTimer.stop()



