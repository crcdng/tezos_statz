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
          _address = storeAddress(address);
        });
      }
    });
  }

  void _validateAndSaveTextField(String field) {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      final address = field;
      setState(() {
        _address = storeAddress(address);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tz address stored')));
      _textFormFieldController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter a valid Tezos address')));
    }
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
    _address = retrieveAddress();
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
                          Container(height: 17.0),
                          CopyableAddress(snapshot.data),
                        ],
                      );
              }),
          Container(height: 34.0),
          Text(
            'Enter a Tz address',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          Container(height: 17.0),
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
          Container(height: 17.0),
          kIsWeb
              ? Container()
              : Column(children: [
                  Text(
                    ' or scan a Tz address or TzStats URL.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(height: 17.0),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: QRView(
                      key: _qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ]),
        ],
      ),
    );
  }
}
