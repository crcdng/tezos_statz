import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';

void main() {
  group('Immutable and comparable entity', () {
    const testReceiverAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testSenderAddress = "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw";
    const testTime = "2023-07-21T21:28:30Z";

    test('TransactionEntity should be immutable and comparable', () {
      expect(
          const TransactionEntity(
                  time: testTime,
                  sender: testSenderAddress,
                  receiver: testReceiverAddress) ==
              const TransactionEntity(
                  time: testTime,
                  sender: testSenderAddress,
                  receiver: testReceiverAddress),
          isTrue);
    });
  });
}
