@tool
extends EditorPlugin

const AUTOLOAD_NAME = "LootLockerSDK"

static var LootLockerSettings = preload("./Game/Internals/LootLockerInternal_Settings.gd")


func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/LootLockerSDK/LootLockerSDK_Autoload.gd")
	LootLockerSettings.GetInstance()

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
