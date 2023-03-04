extends PathFinder

enum STATES {idle,pathfinding,shooting,kicking,runnning}

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
		HoldObject.collision_layer = 0
		add_child(HoldObject)

func _physics_process(delta):
	$PointToTarget.cast_to = position.direction_to(TargetLocation) * (position.distance_to(TargetLocation)+16)
	$JunkDetection.position = Velocity.normalized() * 64
	Pathing = false
	match State:
		STATES.idle:
			pass
		STATES.pathfinding:
			Pathing = true
		STATES.kicking:
			Pathing = false
	if StateCanChange:
		if NavAgent.distance_to_target() <= 512 && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player:
			State = STATES.shooting
		elif not (NavAgent.distance_to_target() <= 256  && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player):
			State = STATES.pathfinding

	
	if NavAgent.distance_to_target() < 200 && $PointToTarget.get_collider() == get_tree().root.get_node("Game").Player:
		Velocity -= position.direction_to(TargetLocation) * (WalkSpeed)
	#Gun Stuff
	if HoldObject != null:
		HoldObject.rotation = position.direction_to(TargetLocation + get_tree().root.get_node("Game").Player.Velocity/2).angle()
func Grab(e):
	.Grab(e)
	DropGun()


func Die():
	DropGun()
	.Die()

func DropGun():
	if HoldObject!= null:
		HoldObject.call_deferred("set","collision_layer",2)
		remove_child(HoldObject)
		HoldObject.Velocity = Velocity
		HoldObject.position = position
		get_parent().call_deferred("add_child", HoldObject)
		HoldObject = null

func _on_PathTimer_timeout():
	TargetPlayer()
func TargetPlayer():
	SetTargetLocation(get_tree().root.get_node("Game").Player.position)


func _on_ShootTimer_timeout():
	if HoldObject != null:
		if Shooting:
			HoldObject.Shoot(true)


func _on_JunkDetection_body_entered(body):
	if body.is_in_group("GrabObject") && not body.is_in_group("Enemy") && body != HoldObject && body != self:
		if StateCanChange:
			State = STATES.kicking
			StateCanChange = false
			$StateChangeTimer.start(0.5)
			kickObject = body
			KickVel = Velocity
			$AnimationPlayer.play("Kick")
func _Kick():
	if kickObject != null:
		kickObject.Collided(KickVel*10,1.0)


func _on_StateChangeTimer_timeout():
	StateCanChange = true
	
