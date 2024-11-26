extends Node
class_name LL_BaseResponse

class LL_ErrorData extends Node:
	@export var code : String
	@export var doc_url : String
	@export var request_id : String
	@export var trace_id : String
	@export var message : String
	@export var retry_after_seconds : int

	func _to_string() -> String:
		return LLInternal_JsonUtilities.ObjectToJsonString(self, false)

@export var success : bool
@export var status_code : int
@export var raw_response_body : String
@export var error_data : LL_ErrorData

func _to_string() -> String:
	return LLInternal_JsonUtilities.ObjectToJsonString(self, false)
