import 'package:equatable/equatable.dart';

class BalanceEntity with EquatableMixin {
  final double amount;
  final double amountInUsd;

  const BalanceEntity({required this.amount, required this.amountInUsd});

  // NOTE instances are equal by the amounts
  @override
  List<Object?> get props => [amount, amountInUsd];
}
