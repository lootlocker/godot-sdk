@tool
extends EditorPlugin

const AUTOLOAD_NAME = "LootLockerSDK"

static var LootLockerSettings = preload("./Game/Internals/LootLockerInternal_Settings.gd")


func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/LootLockerSDK/LootLockerSDK.gd")
	LootLockerSettings.GetInstance().loadSettings()

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)

func _init() -> void:
	LootLockerSettings.GetInstance().loadSettings()
