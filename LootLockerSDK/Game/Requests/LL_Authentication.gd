class_name LL_Authentication
const __SESSION_RESPONSE_FIELDS_TO_CACHE : Array[String] = ["session_token", "player_identifier", "player_name", "player_id", "player_ulid", "wallet_id"]

class LL_BaseSessionResponse extends LootLockerInternal_BaseResponse:
	var session_token : String
	var public_uid : String
	var player_name : String
	var player_created_at : String
	var player_identifier : String
	var player_id : int
	var player_ulid : String
	var seen_before : bool
	var check_grant_notifications : bool
	var check_deactivation_notifications: bool
	var wallet_id : String

class LL_GuestSessionRequest extends LootLockerInternal_BaseRequest:
	var player_identifier : String
	var game_key : String
	var game_version : String
	
	func _init(_player_identifier : String, _game_key : String, _game_version : String):
		player_identifier = _player_identifier
		game_key = _game_key
		game_version = _game_version

class GuestSession extends LootLockerInternal_RequestDefinition:
	func _init(playerIdentifier : String = "") -> void:
		responseType = LL_BaseSessionResponse
		if(playerIdentifier == ""):
			playerIdentifier = LootLockerInternal_LootLockerCache.current().get_data("player_identifier", "")
		request = LL_GuestSessionRequest.new(playerIdentifier, LootLockerInternal_Settings.GetApiKey(), LootLockerInternal_Settings.GetGameVersion())
		super._init("/game/v2/session/guest", LootLockerInternal_HTTPClient.http_methods.POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
	
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response
	
class LL_SteamSessionRequest extends LootLockerInternal_BaseRequest:
	var player_identifier : String
	var platform : String
	var game_key : String
	var game_version : String
	
	func _init(_player_identifier : String, _game_key : String, _game_version : String, _platform : String):
		player_identifier = _player_identifier
		game_key = _game_key
		game_version = _game_version
		platform = _platform

class SteamSession extends LootLockerInternal_RequestDefinition:
	func _init(playerIdentifier : String) -> void:
		responseType = LL_BaseSessionResponse
		request = LL_SteamSessionRequest.new(playerIdentifier, LootLockerInternal_Settings.GetApiKey(), LootLockerInternal_Settings.GetGameVersion(), "steam")
		super._init("/game/v2/session", LootLockerInternal_HTTPClient.http_methods.POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
		
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response		
