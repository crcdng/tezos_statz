import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';

void main() {
  test('TransactionEntity should be immutable and comparable', () {
    const testReceiverAddress = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    const testSenderAddress = "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw";
    const testTime = "2023-07-21T21:28:30Z";

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
}
