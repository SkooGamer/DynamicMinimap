@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"Minimap",
		"Control",
		preload("res://addons/dynamic_minimap/minimap.gd"),
		preload("res://addons/dynamic_minimap/icons/icon.png")
	)

func _exit_tree():
	remove_custom_type("Minimap")
