## Internal LootLocker base class that specifies a generic base format for all HTTP requests so that they have as small a footprint as possible when implemented
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LootLockerInternal_RequestDefinition
extends RefCounted

var responseType = null
var response : LootLockerInternal_BaseResponse = null
var request : LootLockerInternal_BaseRequest = null
var endPoint : String = ""
var HTTPMethod : HTTPClient.Method = HTTPClient.Method.METHOD_GET
var FieldsToCache : Array[String] = []
var AdditionalHeaders : Array[String] = []
var __JsonParser = preload("./LootLockerInternal_JsonUtilities.gd")
var __HTTPClient = preload("./LootLockerInternal_HTTPClient.gd")

static func __MakeErrorResponse(msg : String, statusCode : int = -1) -> LootLockerInternal_BaseResponse:
	var resp = LootLockerInternal_BaseResponse.new()
	resp.raw_response_body = "{ \"message\": \""+msg+"\" }"
	resp.status_code = statusCode
	resp.success = false
	resp.error_data = LootLockerInternal_BaseResponse.LL_ErrorData.new()
	resp.error_data.message = msg
	return resp

## Initialize a request with the neccessary information to successfully send to LootLocker
func _init(_endPoint : String, _HTTPMethod : HTTPClient.Method, _FieldsToCache : Array[String] = []) -> void:
	endPoint = _endPoint
	HTTPMethod = _HTTPMethod
	FieldsToCache = _FieldsToCache
	if responseType == null:
		responseType = LootLockerInternal_BaseResponse
	if request == null:
		request = LootLockerInternal_BaseRequest.new()
		
## Overridable method for specific actions needed after a response has been received
func responseHandler() :
	pass

## Send the configured request to the LootLocker servers
func _send():
	if __HTTPClient == null:
		response = __MakeErrorResponse("No LootLocker HTTP Client available")
	var LootLocker = __HTTPClient.GetInstance()
	if LootLocker == null:
		response = __MakeErrorResponse("LootLocker HTTP Client was not instantiated correctly")
		return
	if __JsonParser == null:
		response = __MakeErrorResponse("No json parser available")
		return
	
	var requestBody = __JsonParser.ObjectToJsonString(request)
	if HTTPMethod == HTTPClient.Method.METHOD_GET || HTTPMethod == HTTPClient.Method.METHOD_HEAD:
		requestBody = ""
	var result = await LootLocker.makeRequest(endPoint, HTTPMethod, requestBody, AdditionalHeaders)
	if !result:
		response = __MakeErrorResponse("Received null result from HTTP Client")
		return
	
	var parsedResponse = __JsonParser.ObjectFromJsonString(result.body, FieldsToCache, responseType)
	if !parsedResponse:
		response = __MakeErrorResponse("Failed to parse result of request: " + endPoint + ", with body " + requestBody + " \n  Returned code " + result.statusCode + " and body " + result.body)
		return
	response = __JsonParser.ObjectFromJsonString(result.body, FieldsToCache, responseType)
	response.raw_response_body = result.body
	response.status_code = result.statusCode
	response.success = result.success
	if result.success:
		response.error_data = null
	else:
		response.error_data = __JsonParser.ObjectFromJsonString(response.raw_response_body, [], LootLockerInternal_BaseResponse.LL_ErrorData)
		response.error_data.retry_after_seconds = result.retryAfterSeconds
	responseHandler()
