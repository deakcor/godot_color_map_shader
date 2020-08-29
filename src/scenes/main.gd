extends Node


var shader_material = preload("res://assets/new_shadermaterial.tres")

func _on_CheckBox_toggled(button_pressed):
	shader_material.set_shader_param("activated",button_pressed)


func _on_Button_pressed():
	$hud/FileDialog.show()



func _on_FileDialog_file_selected(path):
	var img = load(path)
	shader_material.set_shader_param("texture_color_map", img)
	
	$hud/HBoxContainer/Button.icon = img
