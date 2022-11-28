extends Node


onready var SFX = preload("res://scenes/objects/SFX.tscn")
onready var BloodEffect = preload("res://scenes/objects/Effect.tscn")
onready var WoodEffect = preload("res://scenes/objects/effects/Wood.tscn")
onready var Bullet = preload("res://scenes/objects/Bullet.tscn")
onready var RockEffect = preload("res://scenes/objects/effects/Rock.tscn")
var RNG : RandomNumberGenerator = RandomNumberGenerator.new()

var CurLevel = 0
var Levels = ["res://scenes/levels/Test.tscn","res://scenes/levels/Level2.tscn"]

var Objects = [preload("res://scenes/objects/GrabObject.tscn"),preload("res://scenes/objects/Child.tscn"),preload("res://scenes/objects/ThrowObjects/Rock.tscn"),preload("res://scenes/objects/ThrowObjects/Plant.tscn"),preload("res://scenes/objects/ThrowObjects/Chair.tscn"),preload("res://scenes/objects/ThrowObjects/Bottle.tscn"),
preload("res://scenes/objects/ThrowObjects/Guns/Gun.tscn"),preload("res://scenes/objects/ThrowObjects/Guns/Musket.tscn"),preload("res://scenes/objects/ThrowObjects/Guns/Pistol.tscn"),preload("res://scenes/objects/ThrowObjects/Guns/SuperGun.tscn")]

func _ready():
	RNG.randomize()
