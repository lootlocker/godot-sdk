class_name LL_Miscellaneous

class LL_PingResponse extends LootLockerInternal_BaseResponse:
	var date : String

class Ping extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		responseType = LL_PingResponse
		super._init("/game/ping", LootLockerInternal_HTTPClient.http_methods.GET)
	
	func send() -> LL_PingResponse:
		await _send()
		return response
