@tool
class_name LootLockerInternal_Settings

const STAGE_URL : String = "api.stage.internal.dev.lootlocker.cloud"
const PROD_URL : String = "api.lootlocker.com"
const SETTINGS_PATH : String = "res://LootLockerSettings.cfg"
var apiKey : String = ""
var gameVersion : String = ""
var domainKey : String = ""
var url : String

static func _static_init() -> void:
	if Engine.is_editor_hint():
		__CreateSettingsFile()

static func GetApiKey() -> String:
	return GetInstance().apiKey
	
static func GetDomainKey() -> String:
	return GetInstance().domainKey
	
static func GetGameVersion() -> String:
	return GetInstance().gameVersion
	
static func GetUrl() -> String:
	return GetInstance().url

static var _instance : LootLockerInternal_Settings = null;

static func GetInstance() -> LootLockerInternal_Settings:
	if _instance == null:
		_instance = LootLockerInternal_Settings.new()
	return _instance

func _init() -> void:
	var settings = ConfigFile.new()
	var err = settings.load(SETTINGS_PATH)
	if ( err != OK ):
		if Engine.is_editor_hint():
			__CreateSettingsFile()
		printerr("LootLockerError: Could not load settings file. Make sure that res://LootLockerSDK/LL_Settings.cfg exists and is populated with your settings.")
	apiKey = settings.get_value("LootLockerSettings", "api_key", "")
	domainKey = settings.get_value("LootLockerSettings", "domain_key", "")
	gameVersion = settings.get_value("LootLockerSettings", "game_version", "")
	if(apiKey == ""):
		printerr("LootLockerError: Api Key must be configured for LootLocker to work. Set your API key in res://LootLockerSDK/LL_Settings.cfg. You can get your api key from https://console.lootlocker.com/settings/api-keys")
	if(domainKey == ""):
		printerr("LootLockerError: Domain Key must be configured for LootLocker to work. Set your Domain key in res://LootLockerSDK/LL_Settings.cfg. You can get your domain key from https://console.lootlocker.com/settings/api-keys")
	if(domainKey == ""):
		printerr("LootLockerError: Game Version must be configured for LootLocker to work. Set your Game version in res://LootLockerSDK/LL_Settings.cfg. The game version must follow a semver pattern. Read more at https://semver.org/")
	var useStageUrl : bool = settings.get_value("LootLockerInternalSettings", "use_stage_url", false)
	var urlStart = "https://"
	if domainKey != "":
		urlStart += domainKey+"."
	if useStageUrl:
		url = urlStart+STAGE_URL
	else:
		url = urlStart+PROD_URL
	return

static func __CreateSettingsFile():
	if Engine.is_editor_hint() && !FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
		file.store_line("[LootLockerSettings]")
		file.store_line("; You can get your api key from https://console.lootlocker.com/settings/api-keys")
		file.store_line("api_key=\"\"")
		file.store_line("; You can get your domain key from https://console.lootlocker.com/settings/api-keys")
		file.store_line("domain_key=\"\"")
		file.store_line("; The game version must follow a semver pattern. Read more at https://semver.org/")
		file.store_line("game_version=\"\"")
		file.close()
		EditorInterface.get_resource_filesystem().scan()
