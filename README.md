<h1 align="center">LootLocker Godot SDK</h1>

<h1 align="center">
  <a href="https://www.lootlocker.com/"><img src="https://s3.eu-west-1.amazonaws.com/cdn.lootlocker.io/public/lootLocker_wide_dark_whiteBG.png" alt="LootLocker"></a>
</h1>

<p align="center">
  <a href="#about">About</a> •
  <a href="#installation">Installation</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#usage">Usage</a> •
  <a href="#development">Development</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#support">Support</a> •
</p>

---

## About
This is the SDK (Software Development Kit) for interacting with LootLocker's powerful systems from your Godot game. It is a pure GDScript code package provided by the LootLocker team.
LootLocker is a game backend-as-a-service that unlocks cross-platform systems so you can build, ship, and run your best games.

Full documentation is available here https://docs.lootlocker.com/

## Installation

- Go to the [latest release of the LootLocker SDK in GitHub](https://github.com/lootlocker/godot-sdk/releases/latest)
- At the bottom of the release you will find attached assets. Download the zip corresponding to your version of Godot.
- Extract the contents from the downloaded zip file. This will yield a folder named LootLockerSDK.
- Copy the extracted folder (called LootLockerSDK) into your Godot project. Place it into your project's structure in a way that makes sense for you.
- You're all set

## Configuration
- Log on to the [LootLocker management console](https://console.lootlocker.com/login) and find your Game Settings.
- Find your Game Key in the [API section of the settings](https://console.lootlocker.com/settings/api-keys)
- Open or create the file `res://LootLockerSettings.cfg`. The file follows the ini format and needs to have the following settings:
  - First, the header `[LootLockerSettings]`
  - Then `api_key="<your api key from console.lootlocker.com>"`
  - Then `domain_key="<your domain key from console.lootlocker.com>"`
  - And finally `game_version="<a semver representation of the current game version>"`
  - Once you've done this, you will have a file that looks something like this:
  ```ini
  [LootLockerSettings]
  ; You can get your api key from https://console.lootlocker.com/settings/api-keys
  api_key="prod_1c52468fc6e8420c955e3b6c303ea8cc"
  ; You can get your domain key from https://console.lootlocker.com/settings/api-keys
  domain_key="1g9glch3"
  ; The game version must follow a semver pattern. Read more at https://semver.org/
  game_version="1.2.1.4"
  ```
- Optionally: You can configure the log level of the LootLocker SDK by adding  
  ```ini
  ; The configured Log Level for LootLocker, Set to "None" to silence LootLocker logs completely
  ; Possible values are: "Debug", "Verbose", "Info", "Warning", "Error", "None"
  logLevel="Debug"
  ```

## Usage

Now that LootLocker is installed and configured in your project, go ahead and call the LootLocker methods you need. All the LootLocker features that you can use are prefixed with `LL_` and the name of the general feature you want to use. To make calls to LootLocker, the player needs to have authenticated a user. So the first thing you will do is to authenticate which you can do by making a new request from any of the classes in `LL_Authentication`.

Once your player is authenticated you can continue calling any of the exposed LootLocker features you need.

A very basic example of how to sign in a guest user and ping the LootLocker servers to get an "objective" current time would look something like this:
```js
var guestLoginResponse = await LL_Authentication.GuestSession.new().send()
if(!guestLoginResponse.success) :
  printerr("Login failed with reason: " + guestLoginResponse.error_data.to_string())
  return
var pingResponse = await LL_Miscellaneous.Ping.new().send()
if(!pingResponse.success) :
  printerr("Ping towards LootLocker failed with reason: " + pingResponse.error_data.to_string())
  return
```
or if you wanted to authenticate the guest user with an identifier they provide through UI for example you'd call it like this:
```js
var guestLoginResponse = await LL_Authentication.GuestSession.new(<The identifier from the player>).send()
if(!guestLoginResponse.success) :
  printerr("Login failed with reason: " + guestLoginResponse.error_data.to_string())
  return
```

## Exporting your project

LootLocker uses the LootLockerSettings.cfg file that [you configured](#configuration) for its internal workings. So for your exported build to work, you will need to add it to your exported files explicitly.

You do that in Godot by adding `res://LootLockerSettings.cfg` to `Project > Export > (choose your preset) > Resources > Filters to export non-resource files/folders`.

## Development

The LootLocker Godot SDK is provided as open source, and we appreciate community contributions. If you wish to contribute 
- Make a branch for your development
- Follow the existing SDK structure for your additions
- If you are uncertain about anything, ask in our [discord](#support)
- Once you are done, make a pull request in github and get a review from the maintainers
- Once the maintainers accept the pull request, they will merge it and make a release with your changes

## Documentation
For more information on how to use the Godot SDK, [check out our documentation](https://docs.lootlocker.com/).

## Support
If you have any issues or just wanna chat you can reach us on our [Discord Server](https://discord.lootlocker.io/)
