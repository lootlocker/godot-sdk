class_name PlayerName

@export var name : String

static var _resourcePath : String = PlayerName.new().get_script().get_path()

static func FromJson(responseText) -> PlayerName:
	var json = JSON.parse_string(responseText)
	json["@path"] = _resourcePath
	json["@subpath"] = ""
	return dict_to_inst(json)

func ToJson() -> String:
	var dict = inst_to_dict(self)
	dict.erase("@path")
	dict.erase("@subpath")
	return JSON.stringify(dict)
