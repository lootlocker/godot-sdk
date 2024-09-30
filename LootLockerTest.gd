extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var guestSession = await LootLockerAPI.guestLogin()
	print("Identifier:"+guestSession.player_identifier)

	var ping = await LootLockerAPI.ping()
	print("time:"+ping.date)
