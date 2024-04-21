import '../../domain/entities/balance_entity.dart';
import '../../common/extensions.dart' as extensions;

class BalanceModel extends BalanceEntity {
  const BalanceModel({required super.amount, required super.amountInUsd});

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
      amount: extensions.NumberParsing(json['spendable_balance']).toDouble(),
      amountInUsd:
          extensions.NumberParsing(json['spendable_balance_usd']).toDouble());

  BalanceEntity toEntity() =>
      BalanceEntity(amount: amount, amountInUsd: amountInUsd);
}
