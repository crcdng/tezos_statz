import 'package:equatable/equatable.dart';

class TransactionEntity with EquatableMixin {
  final String time;
  final double? volume;
  final String sender;
  final String receiver;

  const TransactionEntity(
      {required this.time,
      this.volume, // not all transactions have a volume
      required this.sender,
      required this.receiver});

  @override
  List<Object?> get props => [time, sender, receiver];
}
