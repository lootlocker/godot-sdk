extends Node
class_name LLInternal_RequestDefinition

var response : LL_BaseResponse = null
var request : LLInternal_BaseRequest = null
var endPoint : String = ""
var HTTPMethod : LLInternal_HTTPClient.http_methods = LLInternal_HTTPClient.http_methods.GET
var FieldsToCache : Array[String] = []

func _init(_endPoint : String, _HTTPMethod : LLInternal_HTTPClient.http_methods, _FieldsToCache : Array[String] = []) -> void:
	endPoint = _endPoint
	HTTPMethod = _HTTPMethod
	FieldsToCache = _FieldsToCache
	if response == null:
		response = LL_BaseResponse.new()
	if request == null:
		request = LLInternal_BaseRequest.new()

func responseHandler() :
	pass

func _send():
	var LootLocker = LLInternal_HTTPClient.GetInstance()
	if LootLocker == null:
		return
	var result = await LootLocker.makeRequest(endPoint, HTTPMethod, LLInternal_JsonUtilities.ObjectToJsonString(request))
	
	response = LLInternal_JsonUtilities.ObjectFromJsonString(result.body, FieldsToCache, response)
	response.raw_response_body = result.body
	response.status_code = result.statusCode
	response.success = result.success
	if result.success:
		response.error_data = null
	else:
		response.error_data = LLInternal_JsonUtilities.ObjectFromJsonString(response.raw_response_body, [], LL_BaseResponse.LL_ErrorData.new())
		response.error_data.retry_after_seconds = result.retryAfterSeconds
	responseHandler()
