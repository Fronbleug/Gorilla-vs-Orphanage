extends Node


onready var SFX = preload("res://scenes/objects/SFX.tscn")
onready var BloodEffect = preload("res://scenes/objects/Effect.tscn")
onready var WoodEffect = preload("res://scenes/objects/effects/Wood.tscn")
onready var Bullet = preload("res://scenes/objects/Bullet.tscn")
var RNG : RandomNumberGenerator = RandomNumberGenerator.new()

var Level = "res://scenes/levels/Test.tscn"

func _ready():
	RNG.randomize()
