import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tezos_statz/model/address.dart';
import 'package:tezos_statz/utils/constants.dart' as constants;

import '../utils/utils.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool _denominationTezos = true;
  String _amountTz = "";
  String _amountUsd = "";

  double parseAmount(data) =>
      json.decode(data.body)[constants.apiBalanceKey] ?? 0.0;

  double parseUSDQuote(data) {
    var quotes = json
        .decode(data.body)
        .where((element) => element["quote"] == "USD")
        .toList();
    double average =
        quotes.fold(0.0, (value, element) => value + element["last"]) /
            quotes.length;
    return average;
  }

  @override
  void initState() {
    super.initState();
    updateBalance();
  }

  updateBalance() async {
    const apiKey = String.fromEnvironment('TZPRO_KEY');
    if (apiKey.isEmpty) {
      throw AssertionError('API KEY is not retrievable');
    }

    var balanceResponse = await retrieveCurrentAddress().then((value) {
      return http.get(
          Uri.https(constants.apiDomain, constants.apiPathAccount + value),
          headers: {"X-API-Key": apiKey});
    });
    var tickerResponse = await http.get(
        Uri.https(constants.apiDomain, constants.apiPathTickers),
        headers: {"X-API-Key": apiKey});
    if (!mounted) return;
    setState(() {
      _amountTz = parseAmount(balanceResponse).toString() + " Tz";
      _amountUsd =
          (parseAmount(balanceResponse) * parseUSDQuote(tickerResponse))
                  .toStringAsFixed(2) +
              " USD";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1)); // extra delay
          setState(() {
            updateBalance();
          });
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: _amountTz == ""
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          SizedBox(
                            height: 100.0,
                            child: AnimatedCrossFade(
                              firstChild: Text(
                                _amountTz,
                                maxLines: 1,
                                key: ValueKey(1),
                                style: TextStyle(fontSize: 28.0),
                              ),
                              secondChild: Text(
                                _amountUsd,
                                maxLines: 1,
                                key: ValueKey(2),
                                style: TextStyle(fontSize: 28.0),
                              ),
                              duration: const Duration(milliseconds: 450),
                              crossFadeState: _denominationTezos
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                            ),
                          ),
                          Container(
                            height: 20.0,
                          ),
                          Text(
                            formatDateTime(DateTime.now()),
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Container(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("USD"),
                              Switch(
                                value: _denominationTezos,
                                onChanged: (bool value) async {
                                  // value
                                  setState(() {
                                    _denominationTezos = value;
                                  });
                                },
                              ),
                              Text("Tz")
                            ],
                          ),
                        ]),
            )),
      ),
    );
  }
}
