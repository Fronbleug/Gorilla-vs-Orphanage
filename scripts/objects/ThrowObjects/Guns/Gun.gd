class_name Gun
extends Weapon


export var Ammo = INF
export var Speed = 1500
export var ShootTime = 0.001
export var ReloadTime = 1.0
export(float,0.001,1.0) var Accuracy = 1.0
export var Auto = false

var CanShoot = true

onready var GunSound = preload("res://audio/gun.ogg")

var Shooting = false

func _ready():
	add_to_group("Gun")

func _physics_process(delta):
	if Grabber != null:
		Grabber.Ammo = Ammo
	if Shooting:
		Shoot(false)
		

func Shoot(enemy):
	if Ammo > 0 and CanShoot:
		print("D21")
		Ammo -= 1
		var SFX = global.SFX.instance()
		SFX.start(GunSound)
		SFX.position = position
		get_parent().add_child(SFX)
		var bullet  = global.Bullet.instance()
		global.RNG.randomize()
		var bulletDir = global.RNG.randf_range(Accuracy,1.0)
		bulletDir -= 1
		bulletDir = abs(bulletDir)
		bulletDir *= 45
		var bulletNeg = global.RNG.randi_range(0,1)
		match bulletNeg:
			0:
				bulletDir *= -1
			1:
				bulletDir *= 1
		if enemy:
			bullet.collision_layer = 32
		
		
		
		
		bullet.Start(Speed, Vector2.RIGHT.rotated(rotation+deg2rad(bulletDir)), $FirePoint.global_position,Damage)
		get_tree().root.get_node("Game").Bullets.add_child(bullet)
		CanShoot = false
		$Timer.start(ShootTime)

func Use():
	if Auto:
		Shooting = true
	else:
		Shoot(false)
func UnUse():
	if Auto:
		Shooting = false

		
		
		


func _on_Timer_timeout():
	CanShoot = true
	$CockingSOund.play()
