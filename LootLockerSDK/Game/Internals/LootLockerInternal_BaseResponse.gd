class_name LootLockerInternal_BaseResponse

class LL_ErrorData:
	var code : String
	var doc_url : String
	var request_id : String
	var trace_id : String
	var message : String
	var retry_after_seconds : int

	func _to_string() -> String:
		var __JsonParser = preload("./LootLockerInternal_JsonUtilities.gd")
		return __JsonParser.ObjectToJsonString(self, false)

var success : bool
var status_code : int
var raw_response_body : String
var error_data : LL_ErrorData

static func __LootLockerInternal_GetReflection() -> Dictionary:
	return { "error_data" : LL_ErrorData }

func _to_string() -> String:
	var __JsonParser = preload("./LootLockerInternal_JsonUtilities.gd")
	return __JsonParser.ObjectToJsonString(self, false)
