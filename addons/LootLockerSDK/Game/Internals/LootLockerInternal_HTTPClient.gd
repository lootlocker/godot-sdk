## Internal LootLocker utility class that is used to send HTTP requests
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
extends HTTPRequest
class_name LootLockerInternal_HTTPClient

static var _instance : LootLockerInternal_HTTPClient = null
static var LootLockerSettings = preload("./LootLockerInternal_Settings.gd")
static var LootLockerLogger = preload("./LootLockerInternal_Logger.gd")
static var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")

static var BASE_HEADERS : Array[String] = [
	"Content-Type: application/json"
]
static var HTTP_METHOD_STRINGS : Array = ["GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "TRACE", "CONNECT", "PATCH"]

static func GetInstance() -> LootLockerInternal_HTTPClient:
	if _instance == null:
		_instance = LootLockerInternal_HTTPClient.new()
	return _instance
	
func _ready() -> void:
	_instance = self
	pass

class LL_HTTPRequestResult:
	var body : String
	var statusCode : int
	var success : bool
	var retryAfterSeconds : int
	
	func _init(_body : String, _statusCode : int, _success : bool, _retryAfterSeconds : int) -> void:
		body = _body
		statusCode = _statusCode
		success = _success
		if _retryAfterSeconds < 0:
			retryAfterSeconds = 2147483647
		retryAfterSeconds = _retryAfterSeconds
		
static func logLootLockerRequest(endpoint, requestType, body, result : LL_HTTPRequestResult):
		var logLevel : LootLockerInternal_Logger.LL_LogLevel = LootLockerInternal_Logger.LL_LogLevel.Verbose if result.success else LootLockerInternal_Logger.LL_LogLevel.Warning
		LootLockerLogger.Log(HTTP_METHOD_STRINGS[requestType] + " to " + endpoint + "\n  with request body "+body+"\n  gave result: "+LootLockerInternal_JsonUtilities.ObjectToJsonString(result), logLevel)

func makeRequest(endpoint, requestType: HTTPClient.Method, body, additionalHeaders : Array[String] = []) -> LL_HTTPRequestResult:
	var httpClient = HTTPClient.new()
	var url = LootLockerSettings.GetUrl()
	
	if !httpClient:
		var res = LL_HTTPRequestResult.new("{ \"message\": \"LootLocker could not create http client\"}", 0, false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	
	var err = httpClient.connect_to_host(url)
	
	if err != OK:
		var res = LL_HTTPRequestResult.new("{ \"message\": \"Could not connect to LootLocker, error code was "+str(err)+"\"}", 0, false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res

	var headers : Array[String] = []
	headers.append_array(BASE_HEADERS)
	# Add session-token if a subsequent request
	var sessionToken = LootLockerCache.current().get_data("session_token", "")
	if(sessionToken != ""):
		headers.append("x-session-token: " + sessionToken)
	
	if(!additionalHeaders.is_empty()):
		for header in additionalHeaders:
			headers.append(header)

	while httpClient.get_status() == HTTPClient.STATUS_CONNECTING or httpClient.get_status() == HTTPClient.STATUS_RESOLVING:
		httpClient.poll()
		await Engine.get_main_loop().process_frame
	
	var httpConnectStatus = httpClient.get_status()
	if httpConnectStatus != HTTPClient.STATUS_CONNECTED:
		var res = LL_HTTPRequestResult.new("{ \"message\": \"Could not connect to LootLocker, http status was "+httpConnectStatus+"\"}", 0, false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	
	err = httpClient.request(requestType as HTTPClient.Method, endpoint, headers, body)

	if err != OK:
		var res = LL_HTTPRequestResult.new("{ \"message\": \"LootLocker request failed with code " + str(err) + "\"}", httpClient.get_response_code(), false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
		
	while httpClient.get_status() == HTTPClient.STATUS_REQUESTING:
		httpClient.poll()
		await Engine.get_main_loop().process_frame
		
	if httpClient.get_status() != HTTPClient.STATUS_BODY || httpClient.get_status() == HTTPClient.STATUS_CONNECTED:
		var res = LL_HTTPRequestResult.new("{ \"message\": \"LootLocker request failed with code " + str(err) + "\"}", httpClient.get_response_code(), false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	
	if(httpClient.has_response()):
		var rb = PackedByteArray()
		while httpClient.get_status() == HTTPClient.STATUS_BODY:
			var chunk = httpClient.read_response_body_chunk()
			if chunk.size() == 0:
				await Engine.get_main_loop().process_frame
			else:
				rb = rb + chunk 
			httpClient.poll()
		var text = rb.get_string_from_ascii()
		
		var code = httpClient.get_response_code()
		var RetryAfterSeconds : int = httpClient.get_response_headers_as_dictionary().get("Retry-After", 2147483647)
		var res = LL_HTTPRequestResult.new(text, code, code >= 200 && code <= 299, RetryAfterSeconds)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	return null
