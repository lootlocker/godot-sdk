class_name LL_Authentication
const __SESSION_RESPONSE_FIELDS_TO_CACHE : Array[String] = ["session_token", "player_identifier", "player_name", "player_id", "player_ulid", "wallet_id"]

class LL_BaseSessionResponse extends LL_BaseResponse:
	@export var session_token : String
	@export var public_uid : String
	@export var player_name : String
	@export var player_created_at : String
	@export var player_identifier : String
	@export var player_id : int
	@export var player_ulid : String
	@export var seen_before : bool
	@export var check_grant_notifications : bool
	@export var check_deactivation_notifications: bool
	@export var wallet_id : String

class LL_GuestSessionRequest extends LLInternal_BaseRequest:
	@export var player_identifier : String
	@export var game_key : String
	@export var game_version : String
	
	func _init(_player_identifier : String, _game_key : String, _game_version : String):
		player_identifier = _player_identifier
		game_key = _game_key
		game_version = _game_version

class GuestSession extends LLInternal_RequestDefinition:
	func _init(playerIdentifier : String) -> void:
		response = LL_BaseSessionResponse.new()
		if(playerIdentifier == ""):
			playerIdentifier = LLInternal_LootLockerCache.current().get_data("player_identifier", "")
		request = LL_GuestSessionRequest.new(playerIdentifier, LLInternal_Settings.GetApiKey(), LLInternal_Settings.GetGameVersion())
		super._init("/game/v2/session/guest", LLInternal_HTTPClient.http_methods.POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
	
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response
	
class LL_SteamSessionRequest extends LLInternal_BaseRequest:
	@export var player_identifier : String
	@export var platform : String
	@export var game_key : String
	@export var game_version : String
	
	func _init(_player_identifier : String, _game_key : String, _game_version : String, _platform : String):
		player_identifier = _player_identifier
		game_key = _game_key
		game_version = _game_version
		platform = _platform

class SteamSession extends LLInternal_RequestDefinition:
	func _init(playerIdentifier : String) -> void:
		response = LL_BaseSessionResponse.new()
		request = LL_SteamSessionRequest.new(playerIdentifier, LLInternal_Settings.GetApiKey(), LLInternal_Settings.GetGameVersion(), "steam")
		super._init("/game/v2/session", LLInternal_HTTPClient.http_methods.POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
		
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response		
