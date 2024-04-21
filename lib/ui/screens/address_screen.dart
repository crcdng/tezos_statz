import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tezos_statz/domain/entities/address_entity.dart';
import 'package:tezos_statz/ui/state/address_notifier.dart';
import 'package:tezos_statz/ui/widgets/copyable_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'qr');
  QRViewController?
      _qrViewController; // null on other platforms than iOS / Android

  final _textFormFieldController = TextEditingController();
  final _player = AudioPlayer();

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      final address = scanData.code!
          .substring(scanData.code!.length - AddressEntity.addressStringLength);
      if (AddressEntity.isValidAddress(address)) {
        _player.setAsset("assets/blip.mp3").then((_) => _player.play());
        _pauseScan();
        Provider.of<AddressNotifier>(context, listen: false).store(address);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Tz address stored')));
      }
    });
  }

  void _validateAndSaveTextField(String field) {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      final address = field;
      Provider.of<AddressNotifier>(context, listen: false).store(address);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tezos address stored')));
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

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // retrieve the stored address as soon as we can access context
    Provider.of<AddressNotifier>(context, listen: false).retrieve();
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
          Consumer<AddressNotifier>(builder: (context, addressNotifier, child) {
            // TODO check if empty address string is possible
            // addressNotifier.addressEntity == null is equivalent to
            // addressNotifier.failure is set
            if (addressNotifier.addressEntity == null ||
                addressNotifier.addressEntity!.address == '') {
              return Container();
            } else {
              return Column(
                children: [
                  Text(
                    'Currently stored address:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(height: 16.0),
                  CopyableAddress(addressNotifier.addressEntity!.address),
                ],
              );
            }
          }),
          Container(height: 19.0),
          Text(
            'Store a Tezos address',
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
                  maxLength: AddressEntity.addressStringLength,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      counter: Container(),
                      border: OutlineInputBorder(),
                      labelText: 'Tezos address'),
                  validator: (value) {
                    if (!AddressEntity.isValidAddress(value)) {
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
          // NOTE kIsWeb needs to be in place here to guard against an exception on web
          (kIsWeb || (!Platform.isAndroid && !Platform.isIOS))
              ? Container()
              : Column(
                  children: [
                    Text(
                      'Scan a Tezos address or TzStats URL',
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
                  ],
                ),
        ],
      ),
    );
  }
}
