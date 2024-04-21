import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezos_statz/ui/state/address_notifier.dart';
import 'package:tezos_statz/ui/state/balance_notifier.dart';

import '../../common/utils.dart' as utils;

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  bool _denominationTezos = true;

  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // retrieve the stored address as soon as we can access context
    Provider.of<AddressNotifier>(context, listen: false).retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressNotifier>(builder:
        (BuildContext context, AddressNotifier addressNotifier, Widget? child) {
      if (addressNotifier.addressEntity == null ||
          addressNotifier.addressEntity!.address == '') {
        return Center(
            child: Text("First store a valid Tezos address in Tab <>"));
      } else {
        Provider.of<BalanceNotifier>(context, listen: false)
            .getBalance(addressNotifier.addressEntity!.address);
        return Center(
          child: RefreshIndicator(
            onRefresh: () async {
              Provider.of<BalanceNotifier>(context, listen: false)
                  .getBalance(addressNotifier.addressEntity!.address);
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
                            firstChild: Consumer<BalanceNotifier>(
                              builder: (context, balanceNotifier, child) {
                                return Text(
                                  balanceNotifier.balance == null
                                      ? ""
                                      : balanceNotifier.balance!.amount
                                          .toString(),
                                  maxLines: 1,
                                  key: ValueKey(1),
                                  style: TextStyle(fontSize: 28.0),
                                );
                              },
                            ),
                            secondChild: Consumer<BalanceNotifier>(
                              builder: (context, balanceNotifier, child) {
                                return Text(
                                  balanceNotifier.balance == null
                                      ? ""
                                      : balanceNotifier.balance!.amountInUsd
                                          .toStringAsFixed(2),
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
                          utils.formatDateTime(DateTime.now()),
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
    });
  }
}
