## LootLocker "namespace" for Miscellaneous requests not fitting in a dedicated namespace
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_Miscellaneous
extends RefCounted

## Response class for pinging the LootLocker servers
class LL_PingResponse extends LootLockerInternal_BaseResponse:
	## The time from the LootLocker servers
	var date : String

## Construct a Ping request.[br]
## Usage:
## [codeblock lang=gdscript]
##var response = await LL_Miscellaneous.Ping.new().send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
## [/codeblock]
class Ping extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = LL_PingResponse
		super._init("/game/ping", HTTPClient.Method.METHOD_GET)
	
	## Send the configured request to the LootLocker servers
	func send() -> LL_PingResponse:
		await _send()
		return response
