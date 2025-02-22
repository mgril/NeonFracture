extends HBoxContainer

@export var fullHeartTexture: Texture2D
@export var emptyHeartTexture: Texture2D
var heartTextureRectArray: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_root().get_node("Root").get_node("Player")
	player.currentHealthUpdated.connect(updateHearts)

	# TODO number of hearts depending on player max health

	for item in get_children(): 
		heartTextureRectArray.append(item)
		# Add texture Rect en fonction de la vie max  
		
func updateHearts(newValue): 
	var fullHeartNumber = newValue
	
	for item in heartTextureRectArray: 
		if fullHeartNumber > 0: 
			fullHeartNumber -= 1
			item.texture = fullHeartTexture
		else:
			item.texture = emptyHeartTexture
