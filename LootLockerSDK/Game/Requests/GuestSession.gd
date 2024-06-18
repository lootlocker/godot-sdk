class_name GuestSession

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

static var _resourcePath : String = GuestSession.new().get_script().get_path()

static func FromJson(responseText) -> GuestSession:
	var json = JSON.parse_string(responseText)
	json["@path"] = _resourcePath
	json["@subpath"] = ""
	LootLockerConfig.set_data("session-token", json["session_token"])
	LootLockerConfig.set_data("player-identifier", json["player_identifier"])
	return dict_to_inst(json)

func ToJson() -> String:
	var dict = inst_to_dict(self)
	dict.erase("@path")
	dict.erase("@subpath")
	return JSON.stringify(dict)
