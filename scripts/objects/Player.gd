extends KinematicBody2D


enum STATES {default,grab,shoot}

var State = STATES.default

var Velocity = Vector2()
var InputDir = Vector2()

onready var Bullet = preload("res://scenes/objects/Bullet.tscn")

var ArmWeight = 0.5


var GrabbedObject = null

var HoverObject = null

export var MaxArmLength = 128

var GrabFloor = false

var GrabFloorPoint = Vector2()
var GrabFloorPosition = Vector2()

var ArmVelocity = Vector2()

var PunchVel = Vector2()

var HandLight = false

onready var GrabSound = preload("res://audio/grab.ogg")
onready var DropSound = preload("res://audio/drop.ogg")
onready var GunSound = preload("res://audio/gun.ogg")



func _physics_process(delta):
	
	if HandLight:
		$Light2D.visible = false
	else:
		$Light2D.visible = true
	
	
	Velocity = lerp(Velocity,Vector2(), 0.05)
	InputDir.x = Input.get_axis("ui_left","ui_right") 
	InputDir.y = Input.get_axis("ui_up","ui_down") 
	
	if InputDir.x < 0:
		$Sprite.flip_h = true
		$Arm/Hand/Hand.flip_v = true
	if InputDir.x >0:
		$Sprite.flip_h = false
		$Arm/Hand/Hand.flip_v = false
	if InputDir != Vector2():
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	
	if HoverObject != null && GrabbedObject!=null && State == STATES.grab:
			
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
	$Arm/Hand/Hand.frame = State
	
	
	$CanvasLayer/Control/cursor.rect_position = get_local_mouse_position().clamped(MaxArmLength)-Vector2(8,8)
	
	PunchVel = ($Arm/Hand.position - handpos)/delta
	
	
	if Input.is_action_just_pressed("Click"):
		if State == STATES.shoot:
			var SFX = global.SFX.instance()
			SFX.start(GunSound)
			SFX.position = position
			get_parent().add_child(SFX)
			var b = Bullet.instance()
			b.Start(2000,$Arm/Hand.position.normalized(),$Arm/Hand.global_position)
			get_parent().Bullets.add_child(b)
		else:
			
			State = STATES.grab
			if HoverObject != null:
				if not $Arm/Hand/Hand/Hand.overlaps_body(HoverObject):
					HoverObject = null
				else:
					var SFX = global.SFX.instance()
					SFX.start(GrabSound)
					SFX.position = position
					get_parent().add_child(SFX)
					GrabbedObject = HoverObject
					GrabbedObject.Grab(self)
			
	if Input.is_action_just_released("Click"):
		if State != STATES.shoot:
			State = STATES.default
			if GrabbedObject != null:
				var SFX = global.SFX.instance()
				SFX.start(DropSound)
				SFX.position = position
				get_parent().add_child(SFX)
				GrabbedObject.UnGrab()
				GrabbedObject = null
	if Input.is_action_just_pressed("LeftClick"):
		
		if GrabbedObject == null:
			State = STATES.shoot
	if Input.is_action_just_released("LeftClick"):
		if State == STATES.shoot:
			State = STATES.default
			
	if Input.is_action_just_pressed("MiddleClick"):
		HandLight = !HandLight


func _on_Hand_body_entered(body):
	if State == STATES.default and (body.is_in_group("GrabObject")):
		HoverObject = body
	elif body.is_in_group("GrabObject") && body != GrabbedObject && State == STATES.grab:
		body.Collided(ArmVelocity)



func _on_Hand_body_exited(body):
	if HoverObject == body and State == STATES.default :
		HoverObject = null
