extends HTTPRequest

var err = 0
var httpRequest = HTTPClient.new()

@export var coreurl : String = "https://api.lootlocker.io"
var headers = [
	"Content-Type: application/json"
]
var apiKey = "dev_0e36be4fb03f4ad091b2c0a379b3250d"
var gameVersion = "0.0.1"

func _guestLogin() -> GuestSession:

	var endpoint = coreurl + "/game/v2/session/guest"
	
	var body = ""
	
	var player_identifier = LootLockerConfig.get_data("player-identifier", "")
	if player_identifier != "":
		body = "{\"game_key\": \"" + apiKey + "\",\"player_identifier\": \"" + player_identifier + "\", \"game_version\": \"" + gameVersion + "\"}"
	else:
		body = "{\"game_key\": \"" + apiKey + "\", \"game_version\": \"" + gameVersion + "\"}"

	err = httpRequest.connect_to_host(coreurl)

	assert(err == OK)
	
	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await get_tree().process_frame
	
	assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	
	err = httpRequest.request(HTTPClient.METHOD_POST, endpoint, headers, body)

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
		return GuestSession.FromJson(text)
		
		
	return null

func _setPlayerName(newname) -> PlayerName:

	var endpoint = coreurl + "/game/player/name"
	headers.append("LL-Version: 2021-03-01")
	
	var token =  LootLockerConfig.get_data("session-token", "")
	if token == "":
		print("No x-session-token provided")
		return

	headers.append("x-session-token: " + token)
	var body = "{\"name\": \"" + newname + "\"}"

	err = httpRequest.connect_to_host(coreurl)

	assert(err == OK)
	
	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await get_tree().process_frame
	
	assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	
	err = httpRequest.request(HTTPClient.METHOD_PATCH, endpoint, headers, body)

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
		return PlayerName.FromJson(text)
		
		
	return null

func _getPlayerName() -> PlayerName:

	var endpoint = coreurl + "/game/player/name"
	headers.append("LL-Version: 2021-03-01")
	
	var token =  LootLockerConfig.get_data("session-token", "")
	if token == "":
		print("No x-session-token provided")
		return

	headers.append("x-session-token: " + token)
	
	err = httpRequest.connect_to_host(coreurl)

	assert(err == OK)
	
	while httpRequest.get_status() == HTTPClient.STATUS_CONNECTING or httpRequest.get_status() == HTTPClient.STATUS_RESOLVING:
		httpRequest.poll()
		await get_tree().process_frame
	
	assert(httpRequest.get_status() == HTTPClient.STATUS_CONNECTED)
	
	err = httpRequest.request(HTTPClient.METHOD_GET, endpoint, headers)

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
		return PlayerName.FromJson(text)
		
		
	return null
