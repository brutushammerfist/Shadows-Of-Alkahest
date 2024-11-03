extends TextureRect

@onready var label = get_node("Label")
@onready var balsam_zero_image = preload("res://assets/images/ui/ui_balsam_0.png")
@onready var balsam_one_image = preload("res://assets/images/ui/ui_balsam_1.png")
@onready var balsam_two_image = preload("res://assets/images/ui/ui_balsam_2.png")
@onready var balsam_three_image = preload("res://assets/images/ui/ui_balsam_3.png")

var player : Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#label.text = str(player.num_balsam_available)

	match player.num_balsam_available:
		0:
			texture = balsam_zero_image
		1:
			texture = balsam_one_image
		2:
			texture = balsam_two_image
		3:
			texture = balsam_three_image
