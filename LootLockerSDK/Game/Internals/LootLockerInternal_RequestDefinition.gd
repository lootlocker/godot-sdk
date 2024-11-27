extends Node
class_name LootLockerInternal_RequestDefinition

var response : LootLockerInternal_BaseResponse = null
var request : LootLockerInternal_BaseRequest = null
var endPoint : String = ""
var HTTPMethod : LootLockerInternal_HTTPClient.http_methods = LootLockerInternal_HTTPClient.http_methods.GET
var FieldsToCache : Array[String] = []

func _init(_endPoint : String, _HTTPMethod : LootLockerInternal_HTTPClient.http_methods, _FieldsToCache : Array[String] = []) -> void:
	endPoint = _endPoint
	HTTPMethod = _HTTPMethod
	FieldsToCache = _FieldsToCache
	if response == null:
		response = LootLockerInternal_BaseResponse.new()
	if request == null:
		request = LootLockerInternal_BaseRequest.new()

func responseHandler() :
	pass

func _send():
	var LootLocker = LootLockerInternal_HTTPClient.GetInstance()
	if LootLocker == null:
		return
	var result = await LootLocker.makeRequest(endPoint, HTTPMethod, LootLockerInternal_JsonUtilities.ObjectToJsonString(request))
	
	response = LootLockerInternal_JsonUtilities.ObjectFromJsonString(result.body, FieldsToCache, response)
	response.raw_response_body = result.body
	response.status_code = result.statusCode
	response.success = result.success
	if result.success:
		response.error_data = null
	else:
		response.error_data = LootLockerInternal_JsonUtilities.ObjectFromJsonString(response.raw_response_body, [], LootLockerInternal_BaseResponse.LL_ErrorData.new())
		response.error_data.retry_after_seconds = result.retryAfterSeconds
	responseHandler()
