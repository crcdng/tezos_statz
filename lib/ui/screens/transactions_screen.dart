import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezos_statz/ui/state/address_notifier.dart';
import 'package:tezos_statz/ui/state/transactions_notifier.dart';

import '../../common/extensions.dart' as extensions;

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // retrieve the stored address as soon as we can access context
    Provider.of<AddressNotifier>(context, listen: false).retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressNotifier>(
      builder: (BuildContext context, AddressNotifier addressNotifier,
          Widget? child) {
        if (addressNotifier.addressEntity == null ||
            addressNotifier.addressEntity!.address == '') {
          return Center(
              child: Text("First store a valid Tezos address in Tab <>"));
        } else {
          Provider.of<TransactionsNotifier>(context, listen: false)
              .getTransactions(addressNotifier.addressEntity!.address);
          return Consumer<TransactionsNotifier>(
              builder: (context, transactionsNotifier, child) {
            if (transactionsNotifier.transactions == null ||
                transactionsNotifier.transactions == []) {
              return Container();
            } else {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                itemCount: transactionsNotifier.transactions!.length,
                itemBuilder: (BuildContext context, int index) {
                  var sender = transactionsNotifier.transactions![index].sender;
                  var receiver = transactionsNotifier
                    ..transactions![index].receiver;
                  var volume = transactionsNotifier
                              .transactions![index].volume !=
                          null
                      ? transactionsNotifier.transactions![index].volume!
                          .toDouble()
                      : 0.0; // an integer number such as 1 from JSON is interpreted as int
                  var time = transactionsNotifier.transactions![index].time;
                  var isExpense =
                      (sender == addressNotifier.addressEntity!.address);
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
                    subtitle: Text(
                        extensions.DateTimeFormatting(DateTime.parse(time))
                            .formatDateTime()),
                  );
                },
              );
            }
          });
        }
      },
    );
  }
}
