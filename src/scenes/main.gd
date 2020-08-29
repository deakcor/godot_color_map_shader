extends Node

var color_maps = [preload("res://assets/textures/color_map.png"), preload("res://assets/textures/color_map2.png")]

var selected_colors:PoolColorArray = []

var current_colors:PoolColorArray = []

var shader_material = preload("res://assets/tree.material")

var shader_leaf_material = preload("res://assets/leaf.material")

func _ready():
	
	get_img_colors(color_maps[0])
	current_colors = selected_colors

func get_img_colors(tex:Texture):
	var img = tex.get_data()
	selected_colors = []
	img.lock()
	for x in img.get_width():
		selected_colors.push_back(img.get_pixel(x,0))
	print(selected_colors[0])


func create_img_with_colors(colors:PoolColorArray = current_colors) -> ImageTexture:
	var img = Image.new()
	img.create(colors.size(),1,false,Image.FORMAT_RGB8)
	for x in img.get_width():
		img.lock()
		img.set_pixel(x,0,colors[x])
	var imageTexture:ImageTexture = ImageTexture.new()
	imageTexture.create_from_image(img)
	return imageTexture
func _on_CheckBox_toggled(button_pressed):
	shader_material.set_shader_param("activated",button_pressed)


func _on_Button_pressed():
	$hud/FileDialog.show()



func _on_FileDialog_file_selected(path):
	var img = load(path)
	shader_material.set_shader_param("texture_color_map", img)
	
	$hud/HBoxContainer/Button.icon = img


func _on_OptionButton_item_selected(index):
	match index:
		0:
			get_img_colors(color_maps[0])
		1:
			get_img_colors(color_maps[1])
	

func _process(delta):
	if current_colors!=selected_colors:
		for i in selected_colors.size():
			current_colors[i] = lerp(current_colors[i],selected_colors[i],delta)
		shader_material.set_shader_param("texture_color_map", create_img_with_colors())
		shader_leaf_material.set_shader_param("texture_color_map", create_img_with_colors())
