extends Node

static var LootLockerSettings = preload("./Game/Internals/LootLockerInternal_Settings.gd")

func _ready() -> void:
	LootLockerSettings.GetInstance()
