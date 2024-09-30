class_name Sessions
static var guestSession = Sessions.GuestSession.new()
class GuestSession:
	extends Sessions
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
	var resourcePath: String = self.get_script().get_path()
	func get_resource_path():
		return self.get_script().get_path()
	static var http_method = LootLockerAPI.http_methods.POST

class Ping:
	@export var success : bool
	@export var date : Dictionary
	static var endPoint = "/game/ping"
	static var resourcePath : String = Sessions.Ping.new().get_script().get_path()
	static var http_method = LootLockerAPI.http_methods.GET
