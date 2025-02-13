## Internal LootLocker base class that specifies a generic base format for all HTTP response bodies so that they work in the flow using [LootLockerInternal_RequestDefinition]
##
## All LootLocker responses will consist of two parts[br]
## - The generic containing information about the request execution. This is what is designed in this base class. With fields such as the HTTP status code and error data (if any)[br]
## - The specific. This is defined in each sub class and the values will be filled in on successfully executed requests.
##[br][color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LootLockerInternal_BaseResponse
extends RefCounted

## Class containing all available and relevant error data[br]
## Not all fields will be filled out all the time.
class LL_ErrorData extends RefCounted:
	## A descriptive code identifying the error.
	var code : String
	## A link to further documentation on the error.
	var doc_url : String
	## A unique identifier of the request to use in contact with support.
	var request_id : String
	## A unique identifier for tracing the request through LootLocker systems, use this in contact with support.
	var trace_id : String
	## If the request was not a success this property will hold any error messages
	var message : String
	## If the request was rate limited (status code 429) or the servers were temporarily unavailable (status code 503) you can use this value to determine how many seconds to wait before retrying
	var retry_after_seconds : int

	func _to_string() -> String:
		var __JsonParser = preload("./LootLockerInternal_JsonUtilities.gd")
		return __JsonParser.ObjectToJsonString(self, false)

## Whether this request was a success
var success : bool
## HTTP Status Code
var status_code : int
## Raw text/http body from the server response
var raw_response_body : String
## If this request was not a success, this structure holds all the information needed to identify the problem. Otherwise this will be null.
var error_data : LL_ErrorData

static func __LootLockerInternal_GetReflection() -> Dictionary:
	return { "error_data" : LL_ErrorData }

func _to_string() -> String:
	var __JsonParser = preload("./LootLockerInternal_JsonUtilities.gd")
	return __JsonParser.ObjectToJsonString(self, false)
