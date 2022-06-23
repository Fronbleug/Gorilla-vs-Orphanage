extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var TileTypes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.get_node("Game").Tilemap = self

func GetTileType(id):
	if TileTypes.keys().has(id):
		return TileTypes[id]
	else:
		return 0
