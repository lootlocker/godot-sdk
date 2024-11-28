extends HTTPRequest
class_name LootLockerInternal_HTTPClient

static var _instance : LootLockerInternal_HTTPClient = null

var err = 0
var httpRequest = HTTPClient.new()
var headers = [
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

class LLHTTPRequestResult:
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
		
static func logLootLockerRequest(endpoint, requestType, body, result : LLHTTPRequestResult):
	if LootLockerInternal_Settings.ShouldLogDebugInformation():
		print("##LootLockerDebug## -- " + HTTP_METHOD_STRINGS[requestType] + " to " + endpoint + "\n  with request body "+body+"\n  gave result: "+LootLockerInternal_JsonUtilities.ObjectToJsonString(result))

func makeRequest(endpoint, requestType: HTTPClient.Method, body) -> LLHTTPRequestResult:
	var url = LootLockerInternal_Settings.GetUrl()
	err = httpRequest.connect_to_host(url)

	if err != OK:
		var res = LLHTTPRequestResult.new("{ \"message\": \"Could not connect to LootLocker, error code was "+err+"\"}", 0, false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res

	# Add session-token if a subsequent request
	var sessionToken = LootLockerInternal_LootLockerCache.current().get_data("session_token", "")
	if(sessionToken != ""):
		headers.append("x-session-token: " + sessionToken)

	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await Engine.get_main_loop().process_frame
	
	var httpConnectStatus = httpRequest.get_status()
	if httpConnectStatus != HTTPClient.STATUS_CONNECTED:
		var res = LLHTTPRequestResult.new("{ \"message\": \"Could not connect to LootLocker, http status was "+httpConnectStatus+"\"}", 0, false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	
	err = httpRequest.request(requestType as HTTPClient.Method, endpoint, headers, body)

	if err != OK:
		var res = LLHTTPRequestResult.new("{ \"message\": \"LootLocker request failed with code " + err + "\"}", httpRequest.get_response_code(), false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
		
	while httpRequest.get_status() == HTTPClient.STATUS_REQUESTING:
		httpRequest.poll()
		await Engine.get_main_loop().process_frame
		
	if httpRequest.get_status() != HTTPClient.STATUS_BODY || httpRequest.get_status() == HTTPClient.STATUS_CONNECTED:
		var res = LLHTTPRequestResult.new("{ \"message\": \"LootLocker request failed with code " + err + "\"}", httpRequest.get_response_code(), false, -1)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	
	if(httpRequest.has_response()):
		var rb = PackedByteArray()
		while httpRequest.get_status() == HTTPClient.STATUS_BODY:
			var chunk = httpRequest.read_response_body_chunk()
			if chunk.size() == 0:
				await Engine.get_main_loop().process_frame
			else:
				rb = rb + chunk 
			httpRequest.poll()
		var text = rb.get_string_from_ascii()
		
		var code = httpRequest.get_response_code()
		var RetryAfterSeconds : int = httpRequest.get_response_headers_as_dictionary().get("Retry-After", 2147483647)
		var res = LLHTTPRequestResult.new(text, code, code >= 200 && code <= 299, RetryAfterSeconds)
		logLootLockerRequest(endpoint, requestType, body, res)
		return res
	return null
