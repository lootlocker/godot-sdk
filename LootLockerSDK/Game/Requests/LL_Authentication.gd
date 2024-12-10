## LootLocker "namespace" for all requests relating to authentication
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_Authentication
extends RefCounted
const __SESSION_RESPONSE_FIELDS_TO_CACHE : Array[String] = ["session_token", "player_identifier", "player_name", "player_id", "player_ulid", "wallet_id"]

## Base response class for authenticating a user towards the LootLocker servers
class LL_BaseSessionResponse extends LootLockerInternal_BaseResponse:
	## The session token that can now be used to use further LootLocker functionality. We store and use this for you.
	var session_token : String
	## The public UID for this player
	var public_uid : String
	## The player's name if any has been set using SetPlayerName.
	var player_name : String
	## The creation time of this player
	var player_created_at : String
	## The unique player identifier for this account
	var player_identifier : String
	## The player id, often named [code]legacy_player_id[/code]
	var player_id : int
	## The ULID for this player
	var player_ulid : String
	## Whether this player has been seen before (true) or is new (false)
	var seen_before : bool
	## Whether this player has new information to check in grants
	var check_grant_notifications : bool
	## Whether this player has new information to check in deactivations
	var check_deactivation_notifications: bool
	## The id of the wallet for this account
	var wallet_id : String

## Request definition for Guest Authentication towards LootLocker
class LL_GuestSessionRequest extends LootLockerInternal_BaseRequest:
	## The identifier for this guest user
	var player_identifier : String
	## The game key as configured in LootLockerSettings.cfg
	var game_key : String
	## The game version as configured in LootLockerSettings.cfg
	var game_version : String
	
	func _init(_player_identifier : String):
		player_identifier = _player_identifier
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		game_key = LootLockerSettings.GetApiKey()
		game_version = LootLockerSettings.GetGameVersion()

## Construct a request for authenticating the player towards the LootLocker servers as a guest user[br]
## Usage:
##[codeblock lang=gdscript]
##var response = await LL_Authentication.GuestSession.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
## [b]Note:[/b] You can alternatively authenticate the guest user with a specific (for example user defined) player identifier like this
## [codeblock lang=gdscript]await LL_Authentication.GuestSession.new("<your custom identifier>").send()[/codeblock]
class GuestSession extends LootLockerInternal_RequestDefinition:
	func _init(playerIdentifier : String = "") -> void:
		responseType = LL_BaseSessionResponse
		if(playerIdentifier == ""):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			playerIdentifier = LootLockerInternal_LootLockerCache.current().get_data("player_identifier", "")
		request = LL_GuestSessionRequest.new(playerIdentifier)
		super._init("/game/v2/session/guest", HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
	
	## Send the configured request to the LootLocker servers
	func send() -> LL_BaseSessionResponse:
		var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd").current()
		LootLockerCache.delete_data("session_token")
		await _send()
		return response
	
## Request definition for Steam Authentication towards LootLocker
class LL_SteamSessionRequest extends LootLockerInternal_BaseRequest:
	## The game key as configured in LootLockerSettings.cfg
	var game_api_key : String
	## The game version as configured in LootLockerSettings.cfg
	var game_version : String
	## The steam ticket set for this authentication request
	var steam_ticket : String
	
	func _init(_steam_ticket : String):
		steam_ticket = _steam_ticket
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		game_api_key = LootLockerSettings.GetApiKey()
		game_version = LootLockerSettings.GetGameVersion()
	
## Request definition for Steam Authentication towards LootLocker
class LL_SteamSessionRequestWithAppId extends LL_SteamSessionRequest:
	## The specific steam app id set for this authentication request
	var steam_app_id : String
	
	func _init(_steam_ticket : String, _steam_app_id : String = ""):
		steam_app_id = _steam_app_id
		super._init(_steam_ticket)

## Construct a request for authenticating the player towards the LootLocker servers as a steam user[br]
## Usage:
##[codeblock lang=gdscript]
##var response = await LL_Authentication.SteamSession.new("<steam ticket>").send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
## [b]Note:[/b] You can alternatively authenticate the steam user with a specific steam app id (in case you have multiple versions of your game)
## [codeblock lang=gdscript]await LL_Authentication.SteamSession.new("<steam ticket>", "<steam app id>").send()[/codeblock]
class SteamSession extends LootLockerInternal_RequestDefinition:
	func _init(steamTicket : String, steamAppId : String = "") -> void:
		responseType = LL_BaseSessionResponse
		if !steamAppId.is_empty():
			request = LL_SteamSessionRequestWithAppId.new(steamTicket, steamAppId)
		else:
			request = LL_SteamSessionRequest.new(steamTicket)
		super._init("/game/session/steam", HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)
		
	## Send the configured request to the LootLocker servers
	func send() -> LL_BaseSessionResponse:
		var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd").current()
		LootLockerCache.delete_data("session_token")
		await _send()
		return response		
