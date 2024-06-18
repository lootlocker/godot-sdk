@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("LootLockerAPI", "res://Addons/Game/LootLockerAPI.gd")
	add_autoload_singleton("LootLockerConfig", "res://Addons/Game/Resources/LootLockerConfig.gd")


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
