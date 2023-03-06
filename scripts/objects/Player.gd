extends KinematicBody2D


enum STATES {default,grab,shoot}
enum TILES {default,ice}

var State = STATES.default

var Velocity = Vector2()
var InputDir = Vector2()

onready var Bullet = preload("res://scenes/objects/Bullet.tscn")

var ArmWeight = 2

const MAXARMLENGTH = 64

var GrabbedObject : GrabObject = null

var HoverObject = null

export var MaxArmLength =64

var GrabFloor = false

var GrabFloorPoint = Vector2()
var GrabFloorPosition = Vector2()

var ArmVelocity = Vector2()

var PunchVel = Vector2()

var Rotation = 0

var HandLight = false

var Mass = 1

var Friction = 0.07

var TileOn = TILES.default

var Ammo = 0

var Punched = false

var Ended = false

var HP = 100


onready var GrabSound = preload("res://audio/grab.ogg")
onready var DropSound = preload("res://audio/drop.ogg")
onready var GunSound = preload("res://audio/gun.ogg")

onready var IceICeBabu = preload("res://audio/IceIceBaby.wav")

func _ready():
	get_tree().root.get_node("Game").Player = self
func _physics_process(delta):
	if GrabbedObject != null:
			if GrabbedObject.is_in_group("Gun"):
					$CanvasLayer/Ammo.text = str("Ammo: ", Ammo)
	else:
		$CanvasLayer/Ammo.text = ""
	
	var tile = get_tree().root.get_node("Game").Tilemap.get_cellv((position/64).round())
	TileOn = get_tree().root.get_node("Game").Tilemap.GetTileType(tile)
	var lastpos = position
	
	var lap =$Arm/Hand/Hand2.get_overlapping_bodies() 
	if lap.size() > 0:
		for body in lap:
			if State == STATES.default:
				if body.is_in_group("GrabObject"):
					HoverObject = body
				elif body.is_in_group("Collect"):
					HoverObject = body
			elif State == STATES.grab:
				if not Punched:
					if body.is_in_group("GrabObject") && body != GrabbedObject:
						body.Collided(PunchVel,ArmWeight)
					elif body.is_in_group("BreakObject"):
						body.Collided(PunchVel,ArmWeight)
					Punched = true
	
	match TileOn:
		TILES.default:
			Friction = 0.07
		TILES.ice:
			if audio.stream !=IceICeBabu:
				audio.stream = IceICeBabu
				audio.play()
			$CanvasLayer/Label.show()
			
			Friction = 0
	
	if HandLight:
		$Light2D.visible = false
	else:
		$Light2D.visible = true
	
	if not Ended:
		Velocity = lerp(Velocity,Vector2(), Friction)
		InputDir.x = Input.get_axis("ui_left","ui_right") 
		InputDir.y = Input.get_axis("ui_up","ui_down") 
	
		if InputDir.x < 0:
			$Sprite.flip_h = true
			$Arm/Hand/Hand.flip_v = true
			if GrabbedObject != null:
				if GrabbedObject.is_in_group("Weapon"):
					GrabbedObject.Flip(true)
		if InputDir.x >0:
			$Sprite.flip_h = false
			$Arm/Hand/Hand.flip_v = false
			if GrabbedObject != null:
				if GrabbedObject.is_in_group("Weapon"):
					GrabbedObject.Flip(false)
		if InputDir != Vector2():
			$AnimationPlayer.play("walk")
			$Particles2D.emitting = true
		else:
			$AnimationPlayer.play("idle")
			$Particles2D.emitting = false
		
		

		
		if GrabbedObject == null:
			Velocity += InputDir * 26
		else:
			Velocity += InputDir * 20
		Velocity = move_and_slide(Velocity)
		Velocity = Velocity.clamped(120000)
		
		if Velocity.length() >= 120000:
			$CanvasLayer/Label.text = str("mph: ???????????")
		else:
		
			$CanvasLayer/Label.text = str("mph: ", ((position-lastpos)).length())
		
		$Arm.set_point_position(0, Vector2())
		var handpos = $Arm/Hand.position
		if (not GrabFloor)||(GrabbedObject == null&&GrabFloor):
			
			
			ArmVelocity = (get_local_mouse_position()-$Arm/Hand.position) * 10 / ArmWeight
			ArmVelocity = $Arm/Hand.move_and_slide(ArmVelocity)
			if $Arm/Hand.position .length() >= MaxArmLength:
				$Arm/Hand.position = $Arm/Hand.position.clamped(MaxArmLength)
			
		elif GrabbedObject != null:

				$Arm.set_point_position(1,GrabFloorPoint - position)
				var GrabFloorOffSet = (get_global_mouse_position()-GrabFloorPoint )
				position = GrabFloorPosition + GrabFloorOffSet
		$Arm.set_point_position(1,$Arm/Hand.position)
		
		$Arm/Hand/Hand.rotation = $Arm/Hand.position.angle()
		Rotation = $Arm/Hand/Hand.rotation
		$Arm/Hand/Hand.frame = State
		
		
		$CanvasLayer/Control/cursor.rect_position = (get_local_mouse_position().clamped(MaxArmLength)/$Camera2D.zoom.x-Vector2(8,8))
		
		PunchVel = ($Arm/Hand.position - handpos)/delta
		
		
		if Input.is_action_just_pressed("Click"):
				var SFX = global.SFX.instance()
				SFX.start(GrabSound)
				SFX.position = position
				get_parent().add_child(SFX)
				State = STATES.grab
				if HoverObject != null:
					if HoverObject.is_in_group("Collect"):
						HoverObject.queue_free()
						HoverObject = null
					else:
						if not $Arm/Hand/Hand2.overlaps_body(HoverObject):
							HoverObject = null
						else:

							GrabbedObject = HoverObject
							GrabbedObject.Grab(self)
							if GrabbedObject.is_in_group("Gun"):
								State = STATES.shoot

				
		if Input.is_action_just_released("Click"):
			Punched = false
			
			var SFX = global.SFX.instance()
			SFX.start(DropSound)
			SFX.position = position
			get_parent().add_child(SFX)
			State = STATES.default
			if GrabbedObject != null:
				GrabbedObject.UnGrab()
				GrabbedObject = null
		if Input.is_action_just_pressed("LeftClick"):
			if GrabbedObject != null:
				GrabbedObject.Use()
		if Input.is_action_just_released("LeftClick"):
			if GrabbedObject != null:
				GrabbedObject.UnUse()
		if Input.is_action_just_pressed("MiddleClick"):
			HandLight = !HandLight
	else:
		Velocity = Vector2()
		ArmVelocity = Vector2()
	if HoverObject != null && GrabbedObject!=null && State == STATES.grab || State == STATES.shoot:
				
				ArmWeight = GrabbedObject.Mass
				GrabbedObject.position = $Arm/Hand.global_position
	else:
			ArmWeight = 1


func End():
	Ended = true


func _on_Hand_body_exited(body):
	if HoverObject == body and State == STATES.default :
		HoverObject = null
	if STATES.grab:
		Punched = false

func ArmPastMax():
	pass




func _on_Damage_body_entered(body):
	if body.is_in_group("Bullet"):
		HP -= 10
		print("poop")
		$HurtSound.play()
