## Internal LootLocker utility class that is used for configuring LootLocker. [br]Settings are configured, edited, and read from res://LootLockerSettings.cfg.
##
## To configure LootLocker, open or create res://LootLockerSettings.cfg. [br]
## The file follows the ini format and needs to have the following settings: [code]api_key="<your api key from console.lootlocker.com>"[/code],
## [code]domain_key="<your domain key from console.lootlocker.com>"[/code], [code]game_version="<a semver representation of the current game version>"[/code]. [br]
## Find your Game Key and Domain Key in the [url=https://console.lootlocker.com/settings/api-keys]API section of the settings[/url]. 
## Once you've done this, you will have a file that looks something like this:
##  [codeblock lang=ini]
##  [LootLockerSettings]
##  ; You can get your api key from https://console.lootlocker.com/settings/api-keys
##  api_key="prod_1c52468fc6e8420c955e3b6c303ea8cc"
##  ; You can get your domain key from https://console.lootlocker.com/settings/api-keys
##  domain_key="1g9glch3"
##  ; The game version must follow a semver pattern. Read more at https://semver.org/
##  game_version="1.2.1.4"
##  ; The configured Log Level for LootLocker, Set to "None" to silence LootLocker logs completely
##  ; Possible values are: "Debug", "Verbose", "Info", "Warning", "Error", "None"
##  logLevel="Info"
## [/codeblock]
##[br][color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LootLockerInternal_Settings
extends Resource

const STAGE_URL : String = "api.stage.internal.dev.lootlocker.cloud"
const PROD_URL : String = "api.lootlocker.com"
const SETTINGS_PATH : String = "res://LootLockerSettings.cfg"
var apiKey : String = ""
var gameVersion : String = ""
var domainKey : String = ""
var url : String
var logLevel : String = ""

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
	
static func GetLogLevel() -> String:
	return GetInstance().logLevel

static var _instance : LootLockerInternal_Settings = null;

static func GetInstance() -> LootLockerInternal_Settings:
	if _instance == null:
		_instance = LootLockerInternal_Settings.new()
	return _instance

func _init() -> void:
	loadSettings()

func loadSettings() -> void:
	var settings = ConfigFile.new()
	var err = settings.load(SETTINGS_PATH)
	if ( err != OK ):
		if Engine.is_editor_hint():
			__CreateSettingsFile()
			err = settings.load(SETTINGS_PATH)
			if ( err != OK ):
				printerr("LootLockerError: Could not load settings file. Make sure that res://LootLockerSDK/LL_Settings.cfg exists and is populated with your settings.")
				return
		else:
			printerr("LootLockerError: Could not load settings file. Make sure that res://LootLockerSDK/LL_Settings.cfg exists and is populated with your settings.")
			return
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
	logLevel = settings.get_value("LootLockerSettings", "logLevel", "Info")
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
		file.store_line("; The configured Log Level for LootLocker, Set to \"None\" to silence LootLocker logs completely")
		file.store_line("; Possible values are: \"Debug\", \"Verbose\", \"Info\", \"Warning\", \"Error\", \"None\"")
		file.store_line("logLevel=\"Info\"")
		file.close()
		if Engine.is_editor_hint(): 
			var editor_interface = Engine.get_singleton("EditorInterface")
			if editor_interface:
				editor_interface.get_resource_filesystem().scan()
