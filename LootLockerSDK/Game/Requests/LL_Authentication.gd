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
	
	func _init(_player_identifier : String):
		player_identifier = _player_identifier
		game_key = LootLockerInternal_Settings.GetApiKey()
		game_version = LootLockerInternal_Settings.GetGameVersion()

class GuestSession extends LootLockerInternal_RequestDefinition:
	func _init(playerIdentifier : String = "") -> void:
		responseType = LL_BaseSessionResponse
		if(playerIdentifier == ""):
			playerIdentifier = LootLockerInternal_LootLockerCache.current().get_data("player_identifier", "")
		request = LL_GuestSessionRequest.new(playerIdentifier)
		super._init("/game/v2/session/guest", HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
	
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response
	
class LL_SteamSessionRequest extends LootLockerInternal_BaseRequest:
	var game_api_key : String
	var game_version : String
	var steam_ticket : String
	
	func _init(_steam_ticket : String):
		steam_ticket = _steam_ticket
		game_api_key = LootLockerInternal_Settings.GetApiKey()
		game_version = LootLockerInternal_Settings.GetGameVersion()
	
class LL_SteamSessionRequestWithAppId extends LL_SteamSessionRequest:
	var steam_app_id : String
	
	func _init(_steam_ticket : String, _steam_app_id : String = ""):
		steam_app_id = _steam_app_id
		super._init(_steam_ticket)

class SteamSession extends LootLockerInternal_RequestDefinition:
	func _init(steamTicket : String, steamAppId : String = "") -> void:
		responseType = LL_BaseSessionResponse
		if !steamAppId.is_empty():
			request = LL_SteamSessionRequestWithAppId.new(steamTicket, steamAppId)
		else:
			request = LL_SteamSessionRequest.new(steamTicket)
		super._init("/game/session/steam", HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
		
	func send() -> LL_BaseSessionResponse:
		await _send()
		return response		
