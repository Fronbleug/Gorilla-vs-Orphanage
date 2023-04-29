extends PathFinder

enum STATES {idle,pathfinding,shooting,kicking,runnning,stunned}

export (PackedScene) var SpawnWeapon = null
var HoldObject : Gun = null 
var Shooting = false

var State = STATES.idle

var StateCanChange = true
var StateTimer = 0.0

var kickObject = null
var KickVel = Vector2()

func _ready():
	add_to_group("Enemy")
	if SpawnWeapon != null:

		HoldObject = SpawnWeapon.instance()
		HoldObject.connect("Grabbed",self,"DropGun")
		add_child(HoldObject)
func _physics_process(delta):
	$PointToTarget.cast_to = position.direction_to(TargetLocation) * (position.distance_to(TargetLocation)+32)
	$JunkDetection.position = Velocity.normalized() * 64
	match State:
		STATES.idle:
			Pathing = false
		STATES.pathfinding:
			Pathing = true
		STATES.kicking:
			Pathing = false
		STATES.stunned:
			Pathing = false
			
	if StateCanChange:
		if path.size() > 0:
			if global_position.distance_to(path[0]) <= 512 && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player:
				State = STATES.shooting
			elif not (global_position.distance_to(path[0]) <= 512  && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player):
				State = STATES.pathfinding

	if path.size() > 0:
		if global_position.distance_to(path[0]) < 128 && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player:
			Velocity -= position.direction_to(TargetLocation) * (WalkSpeed)
	#Gun Stuff
	if HoldObject != null:
		HoldObject.position = Vector2()
		HoldObject.rotation = position.direction_to(TargetLocation + get_tree().root.get_node("Game").Player.Velocity/2).angle()
func Grab(e):
	.Grab(e)
	DropGun()
func Collided(vel,weight):
	State = STATES.stunned
	StateCanChange = false
	$StateChangeTimer.start(0.5)
	.Collided(vel,weight)


func Die():
	DropGun()
	.Die()

func DropGun():
	if HoldObject!= null:
		
		
		HoldObject.Velocity = Velocity * 2
		HoldObject.position = position + Velocity.normalized().rotated(deg2rad(90))*64
		remove_child(HoldObject)
		get_parent().call_deferred("add_child", HoldObject)
		HoldObject = null

func _on_PathTimer_timeout():
	TargetPlayer()
func TargetPlayer():
	SetTargetLocation(get_tree().root.get_node("Game").Player.position)


func _on_ShootTimer_timeout():
	if HoldObject != null:
		if State == STATES.shooting:
			HoldObject.Shoot(true)


func _on_JunkDetection_body_entered(body):
	if body.is_in_group("GrabObject") && not body.is_in_group("Enemy") && body != HoldObject && body != self:
		if StateCanChange:
			State = STATES.kicking
			StateCanChange = false
			$StateChangeTimer.start(0.5)
			kickObject = body
			KickVel = Velocity.normalized()
			$AnimationPlayer.play("Kick")
func _Kick():
	
	if kickObject != null && not kickObject.is_queued_for_deletion():
		kickObject.Collided(KickVel*2000,1.0)


func _on_StateChangeTimer_timeout():
	StateCanChange = true
	
