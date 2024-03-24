import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezos_statz/model/address.dart';

import '../../model/balance.dart';
import '../../utils/utils.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool _denominationTezos = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1)); // extra delay
          final address =
              Provider.of<Address>(context, listen: false).retrieve();
          Provider.of<Balance>(context, listen: false).retrieve(address);
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: AnimatedCrossFade(
                        firstChild: Consumer<Balance>(
                          builder: (context, balance, child) {
                            return Text(
                              balance.amount,
                              maxLines: 1,
                              key: ValueKey(1),
                              style: TextStyle(fontSize: 28.0),
                            );
                          },
                        ),
                        secondChild: Consumer<Balance>(
                          builder: (context, balance, child) {
                            return Text(
                              balance.amountInUsd,
                              maxLines: 1,
                              key: ValueKey(2),
                              style: TextStyle(fontSize: 28.0),
                            );
                          },
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
