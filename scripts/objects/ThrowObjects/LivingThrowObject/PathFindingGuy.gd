class_name PathFinder
extends LivingGrabObject

export var WalkSpeed = 32
export var MoveSpeed = 32
export var TargetLocation = Vector2()


var path = []
var threshold = 4
var nav: Navigation2D = null

var CanPath = true
var Pathing = true
var AtLocation = false
func _ready():
	yield(owner,"ready")
	nav = owner.get_node(owner.nav)
	path = nav.get_simple_path(global_position,TargetLocation,false)

func SetTargetLocation(loc):
	TargetLocation = loc
	path = nav.get_simple_path(global_position,TargetLocation,false)
	
func _physics_process(delta):
	$Line2D.position = -position
	$Line2D.points = path
	Velocity = lerp(Velocity,Vector2(), Friction)
	if CanPath:
		if Pathing:
			if path.size() >0:
				
				if global_position.distance_to(path[0])< threshold:
					path.remove(0)
				else:
					var moveDir = position.direction_to(path[0])
					$WallCast.cast_to = Velocity.normalized() * 512
					if $WallCast.is_colliding():
						if $WallCast.get_collision_point().distance_to(position) <= 64:
							MoveSpeed = WalkSpeed/8
						else:
							MoveSpeed = WalkSpeed
					else:
						MoveSpeed = WalkSpeed
					Velocity += moveDir * MoveSpeed
					Velocity = move_and_slide(Velocity)


func Move():
	if not Pathing:
		.Move()
	









func _on_StunTimer_timeout():
	Pathing = true
func UnGrab():
	.UnGrab()
	$StunTimer.start()
func Grab(e):
	.Grab(e)
	Pathing = false
	$StunTimer.stop()






