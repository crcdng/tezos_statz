import 'package:flutter/foundation.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';
import 'package:tezos_statz/domain/usecases/retrieve_transactions.dart';

import '../../common/errors.dart';

class TransactionsNotifier with ChangeNotifier {
  final RetrieveTransactionsUsecase usecase;
  List<TransactionEntity>? transactions;
  Failure? failure;

  TransactionsNotifier({required this.usecase});

  Future<void> getTransactions(String address) async {
    final result = await usecase(address: address);
    result.fold((failure) {
      this.failure = failure;
    }, (data) {
      transactions = data;
    });
    notifyListeners();
  }
}
