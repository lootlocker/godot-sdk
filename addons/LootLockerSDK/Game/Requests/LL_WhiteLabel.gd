## LootLocker "namespace" for all requests relating to White Label Login
##
##White Label Login enables your game to implement a custom account system, allowing players to sign in using a username (based on the player’s email address) and password specific to your game.[br]
##White Label Login includes customizable reset password and confirm account pages, ensuring a seamless and secure experience that matches your game’s branding.[br]
##[color=light green][b]Copyright (c) 2024 LootLocker.[/b][/color]
class_name LL_WhiteLabel
extends RefCounted

#region Responses

## Response class for White Label login
class _LL_LoginResponse extends LootLockerInternal_BaseResponse:
	## The id of the user
	var id : int = 0
	## The id of the game that the white label user is tied to
	var game_id : int = 0
	## The email of the white label user
	var email : String = ""
	## When this white label user was created
	var created_at : String = ""
	## When this white label user was last updated
	var updated_at : String = ""
	## When this white label user was deleted (if it has been)
	var deleted_at : String = ""
	## When this white label user was validated (if it has been)
	var validated_at : String = ""
	## The token identifying this white label session
	var session_token : String = ""

## Response for signing up a White Label user
class _LL_SignUpResponse extends LootLockerInternal_BaseResponse:
	## The id of the user
	var id : int = 0
	## The id of the game that the white label user is tied to
	var game_id : int = 0
	## The email of the white label user
	var email : String = ""
	## When this white label user was created
	var created_at : String = ""
	## When this white label user was last updated
	var updated_at : String = ""
	## When this white label user was deleted (if it has been)
	var deleted_at : String = ""
	## When this white label user was validated (if it has been)
	var validated_at : String = ""

## Base response class for authenticating a user towards the LootLocker servers
class _LL_BaseSessionResponse extends LootLockerInternal_BaseResponse:
	## The session token that can now be used to use further LootLocker functionality. We store and use this for you.
	var session_token : String
	## The public UID for this player
	var public_uid : String
	## The player's name if any has been set using SetPlayerName.
	var player_name : String
	## The creation time of this player
	var player_created_at : String
	## The unique player identifier for this account
	var player_identifier : String
	## The player id, often named [code]legacy_player_id[/code]
	var player_id : int
	## The ULID for this player
	var player_ulid : String
	## Whether this player has been seen before (true) or is new (false)
	var seen_before : bool
	## Whether this player has new information to check in grants
	var check_grant_notifications : bool
	## Whether this player has new information to check in deactivations
	var check_deactivation_notifications: bool
	## The id of the wallet for this account
	var wallet_id : String

## Base response class for authenticating a user towards the LootLocker servers
class _LL_SessionResponseWithWhiteLabelToken extends _LL_BaseSessionResponse:
	## The token identifying this white label session. Use this in future starts to check the session.
	var white_label_session_token : String

## Response class for requesting player verification (The response is a 204 no content meaning it will be empty unless it failed)
class RequestVerificationResponse extends LootLockerInternal_BaseResponse:
	pass

## Response class for requesting password reset (The response is a 204 no content meaning it will be empty unless it failed)
class RequestResetPasswordResponse extends LootLockerInternal_BaseResponse:
	pass

#endregion

#region Requests Bodies

## Internal request body object
class _LL_LoginRequestBody extends LootLockerInternal_BaseRequest:
	## Email supplied by the user
	var email : String = ""
	## Has to be at least 8 characters long
	var password : String = ""
	## Start a longer session
	var remember : bool = false

## Internal request body object
class _LL_SignUpRequestBody extends LootLockerInternal_BaseRequest:
	## Email supplied by the user
	var email : String = ""
	## Has to be at least 8 characters long
	var password : String = ""

## Internal Request Body Object
class _LL_SessionRequestBody extends LootLockerInternal_BaseRequest:
	## The api key of the game you wish to start a session for
	var game_key : String = ""
	## The version of the game you wish to start a session for
	var game_version : String = ""
	## The email of the white label user to start a LootLocker session for
	var email : String = ""
	## White Label Session Token
	var token : String = ""

## Internal request body object
class _LL_RequestVerificationRequestBody extends LootLockerInternal_BaseRequest:
	## The email of the white label user to request verification for
	var email : String = ""

## Internal request body object
class _LL_RequestResetPasswordRequestBody extends LootLockerInternal_BaseRequest:
	## The email of the white label user to request verification for
	var email : String = ""

#endregion

#region Requests

##Construct an HTTP Request in order to Sign Up a user for a White Label account[br]
##
##If request succeeds, the White Label user has been successfully created.[br]
##For the player to use it for authentication and subsequently for LootLocker Sessions the player needs to have verified their email[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.SignUp.new(<email>, <password>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##	  # Remember to remind the player to verify their email to be able to utilize this new account
##    pass
##[/codeblock][br]
class SignUp extends LootLockerInternal_RequestDefinition:
	func _init(email : String, password : String) -> void:
		responseType = _LL_SignUpResponse
		request = _LL_SignUpRequestBody.new()
		request.email = email
		request.password = password
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		var game_key = LootLockerSettings.GetApiKey()
		var domain_key = LootLockerSettings.GetDomainKey()
		AdditionalHeaders.append("domain-key: " + domain_key)
		AdditionalHeaders.append("is-development: " + "true" if game_key.begins_with("dev_") else "false")

		var url = "/white-label-login/sign-up"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SignUpResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Login a White Label user[br]
##
##Authenticates the player as a LootLocker White Label user[br]
##Unless you have specific needs of authenticating the White Label user separately from starting a LootLocker Session you should be using LL_WhiteLabel.LoginAndStartSession instead[br]
##[b] Note: The player needs to be signed up before you can login with it [/b][br]
##[b] Also Note: This logins (authenticates) the White Label user but does not start a LootLocker session which is what is needed for making LootLocker Requests [/b][br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.Login.new(<email>, <password>, Optionally: true if you want the player to be remembered (session lasts longer), false otherwise).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class Login extends LootLockerInternal_RequestDefinition:
	func _init(email : String, password : String, remember : bool = false) -> void:
		responseType = _LL_LoginResponse
		request = _LL_LoginRequestBody.new()
		request.email = email
		request.password = password
		request.remember = remember
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		var game_key = LootLockerSettings.GetApiKey()
		var domain_key = LootLockerSettings.GetDomainKey()
		AdditionalHeaders.append("domain-key: " + domain_key)
		AdditionalHeaders.append("is-development: " + "true" if game_key.begins_with("dev_") else "false")

		var url = "/white-label-login/login"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	func responseHandler():
		if(response.success):
			var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
			LootLockerCache.current().set_data("white_label_email", response.email)
			LootLockerCache.current().set_data("white_label_session_token", response.session_token)

	## Send the configured request to the LootLocker servers
	func send() -> _LL_LoginResponse:
		await _send()
		return response

##Construct an HTTP Request in order to start a LootLocker session for a White Label authenticated user[br]
##
##Unless you have specific needs of starting a LootLocker session separately from authenticating the White Label user you should be using LL_WhiteLabel.LoginAndStartSession instead[br]
##[b]Note: to start a LootLocker session with a White Label account you need to first have logged in the White Label user [/b]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.StartSession.new(<email>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class StartSession extends LootLockerInternal_RequestDefinition:
	func _init(email : String) -> void:
		responseType = _LL_BaseSessionResponse
		request = _LL_SessionRequestBody.new()
		request.email = email
		var LootLockerCache = preload("../Resources/LootLockerInternal_LootLockerCache.gd")
		request.token = LootLockerCache.current().get_data("white_label_session_token", "")
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		request.game_key = LootLockerSettings.GetApiKey()
		request.game_version = LootLockerSettings.GetGameVersion()

		var url = "/game/v2/session/white-label"
		super._init(url, HTTPClient.Method.METHOD_POST, ["session_token", "player_identifier", "player_name", "player_id", "player_ulid", "wallet_id"])

	## Send the configured request to the LootLocker servers
	func send() -> _LL_BaseSessionResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Login (authenticate) a LootLocker White Label user and start a LootLocker session for that user[br]
##
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.LoginAndStartSession.new(<email>, <password>, Optionally: true if you want the player to be remembered (session lasts longer), false otherwise).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class LoginAndStartSession extends RefCounted:
	var _email : String
	var _password : String
	var _remember : bool
	func _init(email : String, password : String, remember : bool = false) -> void:
		_email = email
		_password = password
		_remember = remember

	## Send the configured request to the LootLocker servers
	func send() -> _LL_SessionResponseWithWhiteLabelToken:
		var loginResponse = await Login.new(_email, _password, _remember).send()
		if(!loginResponse.success):
			var placeHolderResponse = _LL_SessionResponseWithWhiteLabelToken.new()
			placeHolderResponse.error_data = loginResponse.error_data
			return placeHolderResponse
		var startSessionResponse = await StartSession.new(_email).send()
		if(!startSessionResponse.success):
			var placeHolderResponse = _LL_SessionResponseWithWhiteLabelToken.new()
			placeHolderResponse.error_data = startSessionResponse.error_data
			placeHolderResponse.white_label_session_token = loginResponse.error_data
			return placeHolderResponse
		var placeHolderResponse = _LL_SessionResponseWithWhiteLabelToken.new()
		placeHolderResponse.success = startSessionResponse.success
		placeHolderResponse.status_code = startSessionResponse.status_code
		placeHolderResponse.raw_response_body = startSessionResponse.raw_response_body
		placeHolderResponse.error_data = startSessionResponse.error_data
		placeHolderResponse.white_label_session_token = loginResponse.session_token
		placeHolderResponse.session_token = startSessionResponse.session_token
		placeHolderResponse.public_uid = startSessionResponse.public_uid
		placeHolderResponse.player_name = startSessionResponse.player_name
		placeHolderResponse.player_created_at = startSessionResponse.player_created_at
		placeHolderResponse.player_identifier = startSessionResponse.player_identifier
		placeHolderResponse.player_id = startSessionResponse.player_id
		placeHolderResponse.player_ulid = startSessionResponse.player_ulid
		placeHolderResponse.seen_before = startSessionResponse.seen_before
		placeHolderResponse.check_grant_notifications = startSessionResponse.check_grant_notifications
		placeHolderResponse.check_deactivation_notifications = startSessionResponse.check_deactivation_notifications
		placeHolderResponse.wallet_id = startSessionResponse.wallet_id
		return placeHolderResponse

##Construct an HTTP Request in order to Request Verification[br]
##
##This sends out a new email verification email[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.RequestVerification.new(<email>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class RequestVerification extends LootLockerInternal_RequestDefinition:
	func _init(email : String) -> void:
		responseType = RequestVerificationResponse
		request = _LL_RequestVerificationRequestBody.new()
		request.email = email
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		var game_key = LootLockerSettings.GetApiKey()
		var domain_key = LootLockerSettings.GetDomainKey()
		AdditionalHeaders.append("domain-key: " + domain_key)
		AdditionalHeaders.append("is-development: " + "true" if game_key.begins_with("dev_") else "false")

		var url = "/white-label-login/request-verification"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> RequestVerificationResponse:
		await _send()
		return response

##Construct an HTTP Request in order to Request Reset Password[br]
##
##This sends out an email with a password reset link to the user[br]
##Usage:
##[codeblock lang=gdscript]
##var response = await LL_WhiteLabel.RequestResetPassword.new(<email>).send()
##if(!response.success) :
##    # Request failed, handle errors
##    pass
##else:
##    # Request succeeded, use response as applicable in your game logic
##    pass
##[/codeblock][br]
class RequestResetPassword extends LootLockerInternal_RequestDefinition:
	func _init(email : String) -> void:
		responseType = RequestResetPasswordResponse
		request = _LL_RequestResetPasswordRequestBody.new()
		request.email = email
		var LootLockerSettings = preload("../Internals/LootLockerInternal_Settings.gd")
		var game_key = LootLockerSettings.GetApiKey()
		var domain_key = LootLockerSettings.GetDomainKey()
		AdditionalHeaders.append("domain-key: " + domain_key)
		AdditionalHeaders.append("is-development: " + "true" if game_key.begins_with("dev_") else "false")

		var url = "/white-label-login/request-reset-password"
		super._init(url, HTTPClient.Method.METHOD_POST, [])

	## Send the configured request to the LootLocker servers
	func send() -> RequestResetPasswordResponse:
		await _send()
		return response

#endregion
