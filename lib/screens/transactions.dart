import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezos_statz/model/address.dart';
import 'package:tezos_statz/model/transactions.dart';
import 'package:tezos_statz/utils/utils.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({Key? key}) : super(key: key);

  @override
  _TransfersScreenState createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  late String _tzadress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tzadress = Provider.of<Address>(context, listen: false).retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Transactions>(builder: (context, transactions, child) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        itemCount: transactions.items.length,
        itemBuilder: (BuildContext context, int index) {
          var sender = transactions.items[index]["sender"] as String;
          var receiver = transactions.items[index]["receiver"] as String;
          var volume = transactions.items[index]["volume"] != null
              ? transactions.items[index]["volume"].toDouble() as double
              : 0.0; // an integer number such as 1 from JSON is interpreted as int
          var time = transactions.items[index]["time"] as String;
          var isExpense = (sender == _tzadress);
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
      );
    });
  }
}
