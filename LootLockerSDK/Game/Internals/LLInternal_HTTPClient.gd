extends HTTPRequest
class_name LLInternal_HTTPClient

static var _instance : LLInternal_HTTPClient = null

var err = 0
var httpRequest = HTTPClient.new()
var headers = [
	"Content-Type: application/json"
]

enum http_methods {GET = 0, POST = 2, PUT = 3, DELETE = 4, PATCH = 8, }

static func GetInstance() -> LLInternal_HTTPClient:
	if _instance == null:
		_instance = LLInternal_HTTPClient.new()
	return _instance
	
func _ready() -> void:
	_instance = self
	pass

class LLHTTPRequestResult:
	@export var body : String
	@export var statusCode : int
	@export var success : bool
	@export var retryAfterSeconds : int
	
	func _init(_body : String, _statusCode : int, _success : bool, _retryAfterSeconds : int) -> void:
		body = _body
		statusCode = _statusCode
		success = _success
		if _retryAfterSeconds < 0:
			retryAfterSeconds = 2147483647
		retryAfterSeconds = _retryAfterSeconds

func makeRequest(endpoint, requestType: http_methods, body) -> LLHTTPRequestResult:
	var url = LLInternal_Settings.GetUrl()
	err = httpRequest.connect_to_host(url)

	if err != OK:
		return LLHTTPRequestResult.new("Could not connect to LootLocker", 0, false, -1)

	# Add session-token if a subsequent request
	var sessionToken = LLInternal_LootLockerCache.current().get_data("session_token", "")
	if(sessionToken != ""):
		headers.append("x-session-token: " + sessionToken)

	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await Engine.get_main_loop().process_frame
	
	if httpRequest.get_status() != HTTPClient.STATUS_CONNECTED:
		return LLHTTPRequestResult.new("Could not connect to LootLocker", 0, false, -1)
	
	err = httpRequest.request(requestType as HTTPClient.Method, endpoint, headers, body)

	if err != OK:
		return LLHTTPRequestResult.new("LootLocker request failed with code " + err, httpRequest.get_response_code(), false, -1)
		
	while httpRequest.get_status() == HTTPClient.STATUS_REQUESTING:
		httpRequest.poll()
		await Engine.get_main_loop().process_frame
		
	if httpRequest.get_status() != HTTPClient.STATUS_BODY || httpRequest.get_status() == HTTPClient.STATUS_CONNECTED:
		return LLHTTPRequestResult.new("LootLocker request failed with code " + err, httpRequest.get_response_code(), false, -1)
	
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
		return LLHTTPRequestResult.new(text, code, code >= 200 && code <= 299, RetryAfterSeconds)
	return null
