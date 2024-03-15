# Tezos Statz Demo

![](docs/ui.png)

A demonstration app written in [Flutter](https://flutter.dev/) that allows to view [Tezos](https://tezos.com/) blockchain data (balance and list of transactions). On Android and iOS it includes a QR code scanner to scan the Tezos address. 

Tezos Statz Demo calls the TzPro REST API provided by Blockwatch https://blockwatch.cc/.

The TzPro API is documented here: https://docs.tzpro.io/. It requires an API key from Blockwatch that you can get for free here: https://tzpro.io/. 

The code is published under the Apache license. Not affiliated with Blockwatch or Tezos. 

## How to run

This repository contains only the source code. You have to build the app yourself. Get Flutter here https://flutter.dev/docs/get-started/install. Clone this repository and run `flutter create .` or add the target platforms (e.g. Web, iOS, Android, Mac) in your code editor. 

The API key is provided to the app via a configuration file. Ibn the root folder create a file called `api_keys.json`. 

```
{
  "TZPRO_KEY": "<YOUR_API_KEY_HERE>"
}
```

It is important not to check this file into version control. More info about storing API keys in Flutter, obfuscation and other issues: https://codewithandrea.com/articles/flutter-api-keys-dart-define-env-files/

If you deploy to iOS, you need to edit `iOS/Runner/Info.plist` and add the following key for the QR Code scanner to work:

```
<key>NSCameraUsageDescription</key>
<string>This app uses the camera to scan QR codes of Tezos addresses.</string>
```

## Support development

You can support development and creative digital artwork curation by donating to crcrtn.tez / 
tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk 

## 3rd party contributions

Blip sound by: http://jazzy.junggle.net/ (CC BY 3.0)    

## TODO

- replace outdated TzStats API with TzPro API

- overhaul architecture
- add tests

- improve the color scheme
- improve error handling 
- add .tez domain feature 
- load more transactions when paginate limit (100) is reached while scrolling down
- add statistics (view) 
- add detail view for transactions

## DONE

Version 1.0

- create a minimal implementation, model-free (just functions) 🤯
- pull to refresh
- tap to copy donation address  
- balance: show balance in Tz and USD
- make workable Web version (without QRcode scanner)
- store address in Shared Preferences
- animate screen change
- address: show current address
- balance: fix refresh bug
- fixed parse URL scan
- animate USD / Tz switch
- fixed transaction type filter
- address: UI flow Text entry
- address: UI flow QR scan
- address: QR scan sound
- fix late initialization and setState after dispose
- implement an address book with known addresses

Version 1.1

- update Flutter and dependencies


