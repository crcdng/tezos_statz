# Tezos Statz Demo

This is a small WIP demonstration app written in [Flutter](https://flutter.dev/) that allows to view Tezos blockchain data.
On Android / iOS it includes a QR code scanner to scan the address. This web demo does not.

Tezos Statz Demo calls the TzStats REST API provided by https://blockwatch.cc/

The API is documented here: https://tzstats.com/docs/api

The app is published under the Apache license. Not affiliated with TzStats. 

You can support development and creative digital artwork curation by donating to crcrtn.tez / 
tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk 

Blip sound by: http://jazzy.junggle.net/ (CC BY 3.0)

## DONE

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
- balance: fix LateInitializationError

## TODO

- fix The following LateError was thrown while finalizing the widget tree:
LateInitializationError: Field '_qrViewController' has not been initialized.
  
- improve the color scheme
- improve error handling 
- add .tez domain feature 
- load more transactions when paginate limit (100) is reached while scrolling down
- add statistics (view) 
- add detail view for transactions
- implement an address book with known addresses 
