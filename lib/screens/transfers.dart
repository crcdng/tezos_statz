import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tezos_statz/model/address.dart';
import 'package:tezos_statz/utils/constants.dart' as constants;
import 'package:tezos_statz/utils/utils.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({Key? key}) : super(key: key);

  @override
  _TransfersScreenState createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  var _transactions = [];
  late String _tzadress;

  @override
  void initState() {
    super.initState();
    retrieveCurrentAddress().then((value) {
      _tzadress = value;
      _fetchTransactions(value);
    });
  }

  void _fetchTransactions(String address) async {
    final domain = constants.apiDomain;
    final path =
        constants.apiPathAccount + address + constants.apiTransactionsPostfix;
    final parameters = constants.apiTransactionsParameters;
    const apiKey = String.fromEnvironment('TZPRO_KEY');
    if (apiKey.isEmpty) {
      throw AssertionError('API KEY is not retrievable');
    }

    var result = await http.get(Uri.https(domain, path, parameters),
        headers: {"X-API-Key": apiKey});

    if (result.statusCode == 200) {
      setState(() {
        _transactions = json.decode(result.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _transactions.length == 0
        ? Container()
        : RefreshIndicator(
            onRefresh: () async {
              _fetchTransactions(_tzadress);
            },
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              itemCount: _transactions.length,
              itemBuilder: (BuildContext context, int index) {
                var sender = _transactions[index]["sender"] as String;
                var receiver = _transactions[index]["receiver"] as String;
                var volume = _transactions[index]["volume"] != null
                    ? _transactions[index]["volume"].toDouble() as double
                    : 0.0; // an integer number such as 1 from JSON is interpreted as int
                var time = _transactions[index]["time"] as String;
                var isExpense = sender == _tzadress;
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: Icon(
                      isExpense
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      color: isExpense ? Colors.red : Colors.green),
                  title: Text(isExpense
                      ? "Sent $volume Tz to $receiver"
                      : "Received $volume Tz from $sender"),
                  subtitle: Text(formatDateTime(DateTime.parse(time))),
                );
              },
            ),
          );
  }
}
