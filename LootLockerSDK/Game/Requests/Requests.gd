class_name Requests
class GuestSession:
	@export var public_uid : String
	@export var player_name : String
	@export var player_created_at : String
	@export var player_identifier : String
	@export var player_id : int
	@export var player_ulid : String
	@export var seen_before : bool
	@export var check_grant_notifications : bool
	@export var check_deactivation_notifications: bool
	@export var success : bool 
	static var endPoint = "/game/v2/session/guest"
	static var http_method = LootLockerAPI.http_methods.POST

class StartSteamSessionRequest:
	@export var game_key : String
	@export var platform : String
	@export var game_version : String
	@export var player_identifier : String
	static var endPoint = "/game/v2/session"
	static var http_method = LootLockerAPI.http_methods.POST

class StartSteamSessionResponse:
	@export var public_uid : String
	@export var player_name : String
	@export var player_created_at : String
	@export var player_identifier : String
	@export var player_id : int
	@export var player_ulid : String
	@export var seen_before : bool
	@export var check_grant_notifications : bool
	@export var check_deactivation_notifications: bool
	@export var success : bool

class Ping:
	@export var success : bool
	@export var date : String
	static var endPoint = "/game/ping"
	static var http_method = LootLockerAPI.http_methods.GET
