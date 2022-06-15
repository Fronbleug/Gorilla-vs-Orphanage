extends KinematicBody2D





var Velocity = Vector2()
var InputDir = Vector2()


var ArmWeight = 0.5

var Grab = false

var GrabbedObject = null

var HoverObject = null

export var MaxArmLength = 128

var GrabFloor = false

var GrabFloorPoint = Vector2()
var GrabFloorPosition = Vector2()

var ArmVelocity = Vector2()

var PunchVel = Vector2()



func _physics_process(delta):
	
	
	

	
	Velocity = lerp(Velocity,Vector2(), 0.05)
	InputDir.x = Input.get_axis("ui_left","ui_right") 
	InputDir.y = Input.get_axis("ui_up","ui_down") 
	
	
	
	if HoverObject != null && GrabbedObject!=null && Grab:
			
			ArmWeight = GrabbedObject.Weight
			GrabbedObject.position = $Arm/Hand.global_position
	else:
		ArmWeight = 0.5
	
	Velocity += InputDir * 30
	Velocity = move_and_slide(Velocity)
	
	
	$Arm.set_point_position(0, Vector2())
	var handpos = $Arm/Hand.position
	if (not GrabFloor)||(GrabbedObject == null&&GrabFloor):
		
		
		ArmVelocity = (get_local_mouse_position()-$Arm/Hand.position) * 10 * ArmWeight
		ArmVelocity = $Arm/Hand.move_and_slide(ArmVelocity)
		if $Arm/Hand.position .length() >= MaxArmLength:
			$Arm/Hand.position = $Arm/Hand.position.clamped(MaxArmLength)
		
	elif GrabbedObject != null:

			$Arm.set_point_position(1,GrabFloorPoint - position)
			var GrabFloorOffSet = (get_global_mouse_position()-GrabFloorPoint )
			position = GrabFloorPosition + GrabFloorOffSet
	$Arm.set_point_position(1,$Arm/Hand.position)
	
	$Arm/Hand/Hand.rotation = $Arm/Hand.position.angle()
	$Arm/Hand/Hand.frame = int(Input.is_action_pressed("Click"))
	
	
	$cursor.position = get_local_mouse_position().clamped(MaxArmLength)
	
	PunchVel = ($Arm/Hand.position - handpos)/delta
	
	
	if Input.is_action_just_pressed("Click"):
		Grab = true
		if HoverObject != null:
			GrabbedObject = HoverObject
			GrabbedObject.Grab(self)
			
	if Input.is_action_just_released("Click"):
		
		Grab = false
		if GrabbedObject != null:
			GrabbedObject.UnGrab()
			GrabbedObject = null


func _on_Hand_body_entered(body):
	if Grab != true and (body.is_in_group("GrabObject")):
		HoverObject = body
	elif body.is_in_group("GrabObject") && body != GrabbedObject:
		if body.is_in_group("Enemy"):
			body.hurt(PunchVel.length()/20)
		body.Velocity += PunchVel



func _on_Hand_body_exited(body):
	if HoverObject == body and not Grab :
		HoverObject = null
