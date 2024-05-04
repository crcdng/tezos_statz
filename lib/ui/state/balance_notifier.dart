import 'package:flutter/foundation.dart';
import 'package:tezos_statz/domain/usecases/retrieve_balance.dart';
import '../../common/errors.dart';
import '../../domain/entities/balance_entity.dart';

class BalanceNotifier with ChangeNotifier {
  final RetrieveBalanceUsecase usecase;
  BalanceEntity? balance;
  Failure? failure;

  BalanceNotifier({required this.usecase});

  Future<void> getBalance(String address) async {
    final result = await usecase(address: address);
    result.fold((failure) {
      this.failure = failure;
    }, (data) {
      balance = data;
    });
    notifyListeners();
  }
}
