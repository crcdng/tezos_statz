import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/models/transaction_model.dart';
import 'package:tezos_statz/domain/entities/transaction_entity.dart';

import '../../utils/read_json.dart';

void main() {
  late TransactionModel sut;

  const testTransactionModel = TransactionModel(
      time: '2023-07-21T21:28:30Z',
      sender: 'KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC',
      receiver: 'tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk');

  final Map<String, dynamic> testJsonMap =
      json.decode(readJson('test/utils/transaction.json'));

  setUp(() {
    sut = testTransactionModel;
  });

  test('should be a subclass of TransactionEntity', () {
    expect(sut, isA<TransactionEntity>());
  });

  test('should return a of valid model from JSON', () async {
    final model = TransactionModel.fromJson(testJsonMap);

    // instances must be comparable for this test to succeed
    expect(sut, equals(model));
  });
}
