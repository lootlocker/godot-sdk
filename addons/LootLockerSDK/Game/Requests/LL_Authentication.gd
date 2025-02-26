## LootLocker "namespace" for all requests relating to authentication
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_Authentication
extends RefCounted
const __SESSION_RESPONSE_FIELDS_TO_CACHE : Array[String] = ["session_token", "player_identifier", "player_name", "player_id", "public_uid", "player_ulid", "wallet_id"]

#region Responses

## Base response class for authenticating a user towards the LootLocker servers
class _LL_BaseSessionResponse extends LootLockerInternal_BaseResponse:
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

## Response object for a successful request to end session (meaning the request itself was successful, to know if the session was ended check the body)
class _LL_EndSessionResponse extends LootLockerInternal_BaseResponse:
	pass

#endregion

#region Requests Bodies

## Internal Request Body Object
class _LL_GuestSessionRequestBody extends LootLockerInternal_BaseRequest:
	## The api key of the game you wish to start a session for
	var game_key : String = ""
	## The version of the game you wish to start a session for
	var game_version : String = ""
	## Returned on the initial call, then used for subsequent authentication calls, to keep the same guest account active over multiple sessions. 
	var player_identifier : String = ""

## Internal Request Body Object
class _LL_SteamRequestBody extends LootLockerInternal_BaseRequest:
	## API key found undre "API Keys" in the LootLocker console.
	var game_api_key : String = ""
	## The ticket from the signed in steam user on device
	var steam_ticket : String = ""
	## E.g "0.1".
	var game_version : String = ""

## Internal Request Body Object
class _LL_SteamRequestWithAppIdBody extends _LL_SteamRequestBody:
	## Optional. If you have configured multiple Steam App IDs in the console and need to specify which one to use.
	var steam_app_id : String = ""

#endregion

#region Requests

##Construct an HTTP Request in order to End the active LootLocker Session[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Authentication.EndSession.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # On a successfull end session request, the response is a 204 (No Content).
##    pass
##[/codeblock][br]
class EndSession extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = _LL_EndSessionResponse

		var url = "/game/v1/session"
		super._init(url, HTTPClient.Method.METHOD_DELETE, [])

	func responseHandler():
		if(response.success):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			LootLockerCache.current().delete_data("session_token")
			LootLockerCache.current().delete_data("white_label_email")
			LootLockerCache.current().delete_data("white_label_session_token")


	## Send the configured request to the LootLocker servers
	func send() -> _LL_EndSessionResponse:
		await _send()
		return response

##Construct an HTTP Request in order to start a Guest Session[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Authentication.GuestSession.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
##[b]Note:[/b] You can alternatively authenticate the guest user with a specific (for example user defined) player identifier like this
##[codeblock lang=gdscript]await LL_Authentication.GuestSession.new("<your custom identifier>").send()[/codeblock]
class GuestSession extends LootLockerInternal_RequestDefinition:
	func _init(player_identifier : String = "") -> void:
		responseType = _LL_BaseSessionResponse
		if(player_identifier == ""):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			player_identifier = LootLockerCache.current().get_data("player_identifier", "")
		request = _LL_GuestSessionRequestBody.new()
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		request.game_key = LootLockerSettings.GetApiKey()
		request.game_version = LootLockerSettings.GetGameVersion()
		request.player_identifier = player_identifier

		var url = "/game/v2/session/guest"
		super._init(url, HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)

	## Send the configured request to the LootLocker servers
	func send() -> _LL_BaseSessionResponse:
		await _send()
		return response

##Construct an HTTP Request in order to authenticate with Steam[br]
##Usage:
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
	func _init(steam_ticket : String, steam_app_id : String = "") -> void:
		responseType = _LL_BaseSessionResponse
		request = _LL_SteamRequestBody.new() if steam_app_id == "" else _LL_SteamRequestWithAppIdBody.new()
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		request.game_api_key = LootLockerSettings.GetApiKey()
		request.game_version = LootLockerSettings.GetGameVersion()
		request.steam_ticket = steam_ticket
		if(steam_app_id != ""):
			request.steam_app_id = steam_app_id

		var url = "/game/session/steam"
		super._init(url, HTTPClient.Method.METHOD_POST, __SESSION_RESPONSE_FIELDS_TO_CACHE)

	## Send the configured request to the LootLocker servers
	func send() -> _LL_BaseSessionResponse:
		await _send()
		return response
		
static func ParseSteamAuthTicket(buffer : Array, bufferSize : int):
	var HexString : String = ""
	for element in buffer.slice(0, bufferSize):
		HexString += ("%02X" % element)
	return HexString

#endregion
