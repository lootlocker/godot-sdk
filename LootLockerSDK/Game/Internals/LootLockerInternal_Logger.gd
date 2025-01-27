## Internal LootLocker utility class that is used to log messages in a central manner
##
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
extends Node
class_name LootLockerInternal_Logger

static var LootLockerSettings = preload("./LootLockerInternal_Settings.gd")

enum LL_LogLevel { Debug, Verbose, Info, Warning, Error, None }

static func Log(message : String, logLevel : LL_LogLevel):
	if(logLevel == LL_LogLevel.None or message.is_empty()):
		return

	var configuredLogLevelName : String = LootLockerSettings.GetLogLevel()
	var configuredLogLevel : LL_LogLevel = LL_LogLevel.Info;
	if (LL_LogLevel.has(configuredLogLevelName)):
		configuredLogLevel = LL_LogLevel[configuredLogLevelName]

	if (logLevel < configuredLogLevel):
		return

	message = "LL >> " + message
	match(logLevel):
		LL_LogLevel.Error:
			push_error(message)
			printerr(message)
		LL_LogLevel.Warning:
			push_warning(message)
			print_rich("[color=yellow]" + message + "[/color]")
		LL_LogLevel.Verbose:
			print(message)
		LL_LogLevel.Debug:
			print_debug(message)
		_:
			print(message)
	return
