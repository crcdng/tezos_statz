import '../../domain/entities/transaction_entity.dart';
import '../../common/extensions.dart' as extensions;

class TransactionModel extends TransactionEntity {
  const TransactionModel(
      {required super.time,
      super.volume, // not all transactions have a volume
      required super.sender,
      required super.receiver});

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
          time: json['time'] as String,
          volume: extensions.NumberParsing(json['volume']).toDoubleOrNull(),
          sender: json['sender'] as String,
          receiver: json['receiver'] as String);

  TransactionEntity toEntity() => TransactionEntity(
      time: time, volume: volume, sender: sender, receiver: receiver);
}
