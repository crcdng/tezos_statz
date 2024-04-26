import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';

void main() {
  group('Immutable and comparable entity', () {
    const testAmount = 1.0;
    const testAmountUsd = 1.0;

    test('BalanceEntity should be immutable and comparable', () {
      expect(
          const BalanceEntity(amount: testAmount, amountInUsd: testAmountUsd) ==
              const BalanceEntity(
                  amount: testAmount, amountInUsd: testAmountUsd),
          isTrue);
    });
  });
}
