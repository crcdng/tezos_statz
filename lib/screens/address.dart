import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tzstatz/model/address.dart';
import 'package:tzstatz/utils/constants.dart' as constants;
import 'package:tzstatz/widgets/copyable_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'qr');
  QRViewController? _qrViewController; // can be null on the web
  late Future<String> _address;
  late Future<List<String>> _addressBook;

  final _textFormFieldController = TextEditingController();
  final _player = AudioPlayer();

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      final address = scanData.code
          .substring(scanData.code.length - constants.addressLength);
      if (isValidTzAddress(address)) {
        _player.setAsset("assets/blip.mp3").then((_) => _player.play());
        _pauseScan();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Tz address stored')));
        setState(() {
          _address = storeCurrentAddress(address);
          _addressBook = storeInAddressBook(_address);
        });
      }
    });
  }

  void _validateAndSaveTextField(String field) {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      final address = field;
      setState(() {
        _address = storeCurrentAddress(address);
        _addressBook = storeInAddressBook(_address);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tz address stored')));
      _textFormFieldController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text('Please enter a valid Tezos address')));
    }
  }

  Future<void> _scanQRCodeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan QR Code'),
          content: SizedBox(
            width: 150,
            height: 150,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _pauseScan() async {
    await _qrViewController?.pauseCamera().then((_) =>
        Future.delayed(Duration(milliseconds: 1500))
            .then((value) => _qrViewController?.resumeCamera()));
  }

  bool isValidTzAddress(String? str) {
    return (str != null &&
        str.length == constants.addressLength &&
        str.startsWith(constants.addressPrefix));
  }

  @override
  void initState() {
    super.initState();
    _address = retrieveCurrentAddress();
    _addressBook = retrieveAddressBook();
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          FutureBuilder(
              future: _address,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.data == ''
                    ? Container()
                    : Column(
                        children: [
                          Text(
                            'Currently stored Tz address:',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(height: 16.0),
                          CopyableAddress(snapshot.data),
                        ],
                      );
              }),
          Container(height: 19.0),
          Text(
            'Enter a Tz address',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          Container(height: 19.0),
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _textFormFieldController,
                  maxLength: constants.addressLength,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      counter: Container(),
                      border: OutlineInputBorder(),
                      labelText: 'Tz address'),
                  validator: (value) {
                    if (!isValidTzAddress(value)) {
                      return 'invalid';
                    }
                    return null;
                  },
                  onFieldSubmitted: _validateAndSaveTextField,
                ),
              ),
            ),
          ),
          Container(height: 19.0),
          kIsWeb
              ? Container()
              : Column(
                  children: [
                    Text(
                      'Scan a Tz address or TzStats URL',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(height: 19.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                      ),
                      child: Text(
                        'Scan QR Code',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        //The user picked true.
                        _scanQRCodeDialog();
                      },
                    ),
                    Container(height: 19.0),
                    Text(
                      'Select an address from the address book',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(height: 19.0),
                    FutureBuilder(
                        future: _addressBook,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return !snapshot.hasData
                              ? Container()
                              : Column(
                                  children: [
                                    for (var entry in snapshot.data)
                                      ListTile(
                                        leading: const Icon(Icons.code),
                                        title: Text(
                                          entry.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        trailing: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              _addressBook =
                                                  removeFromAddressBook(
                                                      entry.toString());
                                            });
                                          },
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _address = storeCurrentAddress(
                                                entry.toString());
                                          });
                                        },
                                      ),
                                    Container(height: 16.0),
                                  ],
                                );
                        }),
                  ],
                ),
        ],
      ),
    );
  }
}
