extends HTTPRequest

var err = 0
var httpRequest = HTTPClient.new()
var coreurl : String = "https://api.lootlocker.io"
var headers = [
	"Content-Type: application/json"
]
var apiKey = "dev_e9601a51cc044ec88d9738bf173a239b"
var gameVersion = "0.0.1"

enum http_methods {GET = 0, POST = 2, PUT = 3, DELETE = 4, PATCH = 8, }

# Guest login
# TODO: Documentation
func guestLogin() -> Sessions.GuestSession:
	var player_identifier = LootLockerConfig.get_data("player_identifier", "")
	var body = "{\"game_key\": \"" + apiKey + "\", \"game_version\": \"" + gameVersion
	if player_identifier != "":
		body += "\",\"player_identifier\": \"" + player_identifier
	body += "\", \"game_version\": \"" + gameVersion + "\"}"

	var guestRequest = await makeRequest(Sessions.GuestSession.endPoint, Sessions.GuestSession.http_method, body, false)
	var session = Sessions.GuestSession.new()
	#session._init()
	print("resoucePath:"+session.get_resource_path())
	# Parse into the desired class
	return FromJson(guestRequest, ["player_identifier", "session_token"], session.get_resource_path()) as Sessions.GuestSession

func ping() -> Sessions.Ping:
	var pingRequest = await makeRequest(Sessions.Ping.endPoint, Sessions.Ping.http_method, "", true)
	# Parse into the desired class
	return FromJson(pingRequest, [], Sessions.Ping.resourcePath) as Sessions.Ping

# Make into class from JSON
static func FromJson(json_string, data_to_set: Array, resourcePath):
	var json = JSON.parse_string(json_string)
	json["@path"] = resourcePath
	print("resoucePath:"+resourcePath)
	json["@subpath"] = ""
	for i in json.size():
		for j in data_to_set.size():
			if data_to_set[j] == json.keys()[i]:
				LootLockerConfig.set_data(json.keys()[i], json.values()[i])
			pass
	return dict_to_inst(json)

# TODO: Remove asserts and handle errors properly, do not want to halt/crash the game
func makeRequest(endpoint, requestType: http_methods, body, subsequentRequest):
	err = httpRequest.connect_to_host(coreurl)

	assert(err == OK)

	# Add session-token if a subsequent request
	if(subsequentRequest):
		var token =  LootLockerConfig.get_data("session_token", "")
		if token == "":
			print("No x-session-token provided")
			return
		print("x-session-token provided:"+token)
		headers.append("x-session-token: " + token)

	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await get_tree().process_frame
	
	assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	
	err = httpRequest.request(requestType as HTTPClient.Method, endpoint, headers, body)

	assert(err == OK)
	
	while httpRequest.get_status() == HTTPClient.STATUS_REQUESTING:
		httpRequest.poll()
		await get_tree().process_frame
		
	assert(httpRequest.get_status() == HTTPClient.STATUS_BODY or httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	
	
	if(httpRequest.has_response()):
		var rb = PackedByteArray()
		while httpRequest.get_status() == HTTPClient.STATUS_BODY:
			httpRequest.poll()
			var chunk = httpRequest.read_response_body_chunk()
			if chunk.size() == 0:
				await get_tree().process_frame
			else:
				rb = rb + chunk 
		var text = rb.get_string_from_ascii()
		
		# Printing for debugging
		print(text)
		return text

# Commented out for now, not upgraded to the new way of doing requests
func _setPlayerName(newname) -> PlayerName:
	#
	#var endpoint = coreurl + "/game/player/name"
	#headers.append("LL-Version: 2021-03-01")
	#
	#var token =  LootLockerConfig.get_data("session-token", "")
	#if token == "":
		#print("No x-session-token provided")
		#return
#
	#headers.append("x-session-token: " + token)
	#var body = "{\"name\": \"" + newname + "\"}"
#
	#err = httpRequest.connect_to_host(coreurl)
#
	#assert(err == OK)
	#
	#while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		#httpRequest.poll()
		#await get_tree().process_frame
	#
	#assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	#
	#err = httpRequest.request(HTTPClient.METHOD_PATCH, endpoint, headers, body)
#
	#assert(err == OK)
	#
	#while httpRequest.get_status() == HTTPClient.STATUS_REQUESTING:
		#httpRequest.poll()
		#await get_tree().process_frame
		#
	#assert(httpRequest.get_status() == HTTPClient.STATUS_BODY or httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	#
	#
	#if(httpRequest.has_response()):
		#var rb = PackedByteArray()
#
		#while httpRequest.get_status() == HTTPClient.STATUS_BODY:
#
			#httpRequest.poll()
			#var chunk = httpRequest.read_response_body_chunk()
			#if chunk.size() == 0:
				#await get_tree().process_frame
			#else:
				#rb = rb + chunk 
		#var text = rb.get_string_from_ascii()
		#return PlayerName.FromJson(text)
		#
		
	return null

# Commented out for now, not upgraded to the new way of doing requests
func _getPlayerName() -> PlayerName:

	#var endpoint = coreurl + "/game/player/name"
	#headers.append("LL-Version: 2021-03-01")
	#
	#var token =  LootLockerConfig.get_data("session-token", "")
	#if token == "":
		#print("No x-session-token provided")
		#return
#
	#headers.append("x-session-token: " + token)
	#
	#err = httpRequest.connect_to_host(coreurl)
#
	#assert(err == OK)
	#
	#while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		#httpRequest.poll()
		#await get_tree().process_frame
	#
	#assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	#
	#err = httpRequest.request(HTTPClient.METHOD_GET, endpoint, headers)
#
	#assert(err == OK)
	#
	#while httpRequest.get_status() == HTTPClient.STATUS_REQUESTING:
		#httpRequest.poll()
		#await get_tree().process_frame
		#
	#assert(httpRequest.get_status() == HTTPClient.STATUS_BODY or httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	#
	#
	#if(httpRequest.has_response()):
		#var rb = PackedByteArray()
#
		#while httpRequest.get_status() == HTTPClient.STATUS_BODY:
#
			#httpRequest.poll()
			#var chunk = httpRequest.read_response_body_chunk()
			#if chunk.size() == 0:
				#await get_tree().process_frame
			#else:
				#rb = rb + chunk 
		#var text = rb.get_string_from_ascii()
		#return PlayerName.FromJson(text)
		#
		
	return null
