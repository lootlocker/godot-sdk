## LootLocker "namespace" for all requests relating to Players
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_Players
extends RefCounted


#region Data Definitions

## Object containing important player information
class _LL_PlayerInformation:
	## The id of the player. This id is in the form a ULID and is sometimes called player_ulid or similar
	var id : String = ""
	## The legacy id of the player. This id is in the form of an integer and are sometimes called simply player_id or id
	var legacy_id : int = 0
	## The public uid of the player. This id is in the form of a UID
	var public_uid : String = ""
	## When this player was first created
	var created_at : String = ""
	## The name of the player expressly configured through an Update Player Name call
	var name : String = ""

#endregion

#region Responses

## Response object for setting the player profile to be public. Unless the request failed this response will be empty since the successfull response is a 204 (No Content)
class _LL_SetPlayerProfilePublicResponse extends LootLockerInternal_BaseResponse:
	pass

## Response object for setting the player profile to be private. Unless the request failed this response will be empty since the successfull response is a 204 (No Content)
class _LL_SetPlayerProfilePrivateResponse extends LootLockerInternal_BaseResponse:
	pass

## Response object for getting the configured name (if any) for the currently active player
class _LL_GetPlayersActiveNameResponse extends LootLockerInternal_BaseResponse:
	## The name configured for this player
	var name : String = ""

## Response object for setting the player name
class _LL_SetPlayerNameResponse extends LootLockerInternal_BaseResponse:
	## Name the player chose to input, unchanged.
	var name : String = ""

## Response object for deleting the currently signed in player. Unless the request failed this response will be empty since the successfull response is a 204 (No Content)
class DeletePlayerResponse extends LootLockerInternal_BaseResponse:
	pass

## Response object with information about the currently signed in player
class _LL_GetInfoFromSessionResponse extends LootLockerInternal_BaseResponse:
	## Data object containing important information about the player
	var info : _LL_PlayerInformation
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"info" : _LL_PlayerInformation,
		}

## Response object with information about the successfully looked up players. Note that the request can succeed without *all* the requested players being successfully looked up.
class _LL_ListPlayerInfoResponse extends LootLockerInternal_BaseResponse:
	## List of objects containing important player information
	var info : Array[_LL_PlayerInformation] = []
	static func __LootLockerInternal_GetReflection() -> Dictionary:
		return {
			"info" : _LL_PlayerInformation,
		}

#endregion

#region Requests Bodies

## Internal request body object
class _LL_SetPlayerNameRequestBody extends LootLockerInternal_BaseRequest:
	## Name the player wants to input. Note that LootLocker does not provide any validation / moderation against player names.
	var name : String = ""

## Internal request body object
class _LL_ListPlayerInfoRequestBody extends LootLockerInternal_BaseRequest:
	## List of ids you want to look up player information for. These ids are in the form of ULIDs and is sometimes called player_ulid or similar
	var player_id : Array[String] = []
	## List of legacy ids you want to look up player information for. These ids are in the form of integers and are sometimes called simply player_id or id
	var player_legacy_id : Array[int] = []
	## List of public uids you want to look up player information for. These ids are in the form of UIDs
	var player_public_uid : Array[String] = []

#endregion

#region Requests

##Construct an HTTP Request in order to Set Player Profile Public[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.SetPlayerProfilePublic.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class SetPlayerProfilePublic extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = _LL_SetPlayerProfilePublicResponse

		var url = "/game/v1/player/profile/public"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SetPlayerProfilePublicResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Set Player Profile Private[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.SetPlayerProfilePrivate.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class SetPlayerProfilePrivate extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = _LL_SetPlayerProfilePrivateResponse

		var url = "/game/v1/player/profile/public"
		super._init(url, HTTPClient.Method.METHOD_DELETE, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SetPlayerProfilePrivateResponse:
		await _send()
		return response

##Construct an HTTP Request in order to get the currently signed in player's configured name[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.GetPlayersActiveName.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetPlayersActiveName extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = _LL_GetPlayersActiveNameResponse

		var url = "/game/player/name"
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	func responseHandler():
		if(response.success):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			LootLockerCache.current().set_data("player_name", response.name)


	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetPlayersActiveNameResponse:
		await _send()
		return response

##Construct an HTTP Request in order to set the name of the currently signed in player[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.SetPlayerName.new(<new name>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class SetPlayerName extends LootLockerInternal_RequestDefinition:
	func _init(name : String) -> void:
		responseType = _LL_SetPlayerNameResponse
		request = _LL_SetPlayerNameRequestBody.new()
		request.name = name

		var url = "/game/player/name"
		super._init(url, HTTPClient.Method.METHOD_PATCH, [])

	func responseHandler():
		if(response.success):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			LootLockerCache.current().set_data("player_name", response.name)

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SetPlayerNameResponse:
		await _send()
		return response

##Construct an HTTP Request in order to delete the currently signed in player[br]
##
## [b][color = red] THIS IS A DESTRUCTIVE ACTION [/color][b]
## Deletes the currently signed in player's LootLocker account
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.DeletePlayer.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class DeletePlayer extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = DeletePlayerResponse

		var url = "/game/player"
		super._init(url, HTTPClient.Method.METHOD_DELETE, [])

	func responseHandler():
		if(response.success):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			LootLockerCache.current().clear()

	## Send the configured request to the LootLocker servers
	func send() -> DeletePlayerResponse:
		await _send()
		return response

##Construct an HTTP Request in order to retreive important information about the currently signed in player[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_Players.GetInfoFromSession.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class GetInfoFromSession extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = _LL_GetInfoFromSessionResponse

		var url = "/game/player/hazy-hammock/v1/info"
		super._init(url, HTTPClient.Method.METHOD_GET, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_GetInfoFromSessionResponse:
		await _send()
		return response

##Construct an HTTP Request in order to list important player information about the specified players[br]
##
##Look up important information about a set of players.[br]
##You can provide ids of players to look up in three different forms, their ulids, their legacy ids, or their public uids.[br]
##You can mix and match freely between the ids. As long as a player matches an id in one of the arrays it will be returned.[br]
##[b] Note: The response will succeed as long as at least 1 player was successfully looked up. [/b] In other words, not all requested players are neccessarily in the response information array [br]
##Usage:
##[codeblock lang=gdscript]
##var playerIdsToLookUp : Array[String] = [] # These are the ulids of players you want to look up
##var playerLegacyIdsToLookUp : Array[String] = [] # These are the legacy ids of players you want to look up. This identifier takes the form of an integer and is sometimes (for older methods) named simply id
##var playerPublicUidsToLookUp : Array[String] = [] # These are the public uids of players you want to look up
##var response = await LL_Players.ListPlayerInfo.new(playerIdsToLookUp, playerLegacyIdsToLookUp, playerPublicUidsToLookUp).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class ListPlayerInfo extends LootLockerInternal_RequestDefinition:
	## (Optional) [param playerIds] - List of ids you want to look up player information for. These ids are in the form of ULIDs and is sometimes called player_ulid or similar[br]
	## (Optional) [param playerLegacyIds] - List of legacy ids you want to look up player information for. These ids are in the form of integers and are sometimes called simply player_id or id[br]
	## (Optional) [param playerPublicUids] - List of public uids you want to look up player information for. These ids are in the form of UIDs[br]
	func _init(playerIds : Array[String] = [], playerLegacyIds : Array[int] = [], playerPublicUids : Array[String] = []) -> void:
		responseType = _LL_ListPlayerInfoResponse
		request = _LL_ListPlayerInfoRequestBody.new()
		request.player_id = playerIds
		request.player_legacy_id = playerLegacyIds
		request.player_public_uid = playerPublicUids

		var url = "/game/player/hazy-hammock/v1/info"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_ListPlayerInfoResponse:
		await _send()
		return response

#endregion
