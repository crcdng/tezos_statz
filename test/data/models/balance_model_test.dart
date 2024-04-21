import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/data/models/balance_model.dart';
import 'package:tezos_statz/domain/entities/balance_entity.dart';
import '../../utils/read_json.dart';

void main() {
  late BalanceModel sut;

  const testBalanceModel = BalanceModel(amount: 0.869021, amountInUsd: 1.23);

  final Map<String, dynamic> testJsonMap =
      json.decode(readJson('test/utils/balance_constructed.json'));

  setUp(() {
    sut = testBalanceModel;
  });

  test('should be a subclass of BalanceEntity', () {
    expect(sut, isA<BalanceEntity>());
  });

  test('should return a valid model from JSON', () async {
    final model = BalanceModel.fromJson(testJsonMap);

    // instances must be comparable for this test to succeed
    expect(sut, equals(model));
  });
}
