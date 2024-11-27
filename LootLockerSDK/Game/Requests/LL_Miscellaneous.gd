class_name LL_Miscellaneous

class LL_PingResponse extends LootLockerInternal_BaseResponse:
	@export var date : String

class Ping extends LootLockerInternal_RequestDefinition:
	func _init() -> void:
		response = LL_PingResponse.new()
		super._init("/game/ping", LootLockerInternal_HTTPClient.http_methods.GET)
		
#	func responseHandler():
#		if(!response.success):
#			return
#		var resp = LootLockerInternal_JsonUtilities.ObjectFromJsonString(response.raw_response_body, [], LL_PingResponse.new())
#		resp.raw_response_body = response.raw_response_body
#		resp.status_code = response.status_code
#		resp.success = response.success
#		response = resp
	
	func send() -> LL_PingResponse:
		await _send()
		return response
