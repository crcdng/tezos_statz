import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tezos_statz/data/tezos_api.dart';
import 'package:tezos_statz/model/transactions.dart';

class MockApi extends Mock implements TezosApi {}

void main() {
  late MockApi mockApi;
  late Transactions sut;
  const exampleTransactions = [
    {
      "id": 256767623394,
      "hash": "oomQGnTJoCMBUfQkxEtCW32WGVxR9Ed3P7Hgke6p7E47Z9pL9HN",
      "type": "transaction",
      "block": "BKoMf6Ziwm2nyZgzgDbf2zCrWBTQMcQmY5gQaJMUyDePxZTXzWS",
      "time": "2023-07-21T21:28:30Z",
      "height": 3917963,
      "cycle": 632,
      "counter": 7,
      "op_n": 226,
      "op_p": 4,
      "status": "applied",
      "is_success": true,
      "is_internal": true,
      "gas_used": 100,
      "volume": 0.4125,
      "sender": "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC",
      "receiver": "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
      "source": "tz1KxjakCmqHhSEs1CCw7Uo1d2cnp38WfVmw",
      "confirmations": 1386708
    },
    {
      "id": 242162008309,
      "hash": "opQosRQZ8BifGvnUHsHPXxfvDUyimBQ8UyGH1DcGdYs1Do5g3GN",
      "type": "transaction",
      "block": "BLpSmrJ2W4jfHk3eZ3VZ6CxmCmM27GkQfKEiSdGjbVSDdNDSESG",
      "time": "2023-06-12T13:52:40Z",
      "height": 3695099,
      "cycle": 619,
      "counter": 4,
      "op_n": 245,
      "op_p": 4,
      "status": "applied",
      "is_success": true,
      "is_contract": true,
      "is_internal": true,
      "gas_used": 1217,
      "volume": 1,
      "code_hash": "099cd7010843b596",
      "sender": "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
      "receiver": "KT1W56o8dK5En5hM46VsD1zKtgpqWPhs3bLh",
      "source": "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
      "confirmations": 1609572
    },
    {
      "id": 242162008308,
      "hash": "opQosRQZ8BifGvnUHsHPXxfvDUyimBQ8UyGH1DcGdYs1Do5g3GN",
      "type": "transaction",
      "block": "BLpSmrJ2W4jfHk3eZ3VZ6CxmCmM27GkQfKEiSdGjbVSDdNDSESG",
      "time": "2023-06-12T13:52:40Z",
      "height": 3695099,
      "cycle": 619,
      "counter": 3,
      "op_n": 244,
      "op_p": 4,
      "status": "applied",
      "is_success": true,
      "is_contract": true,
      "is_internal": true,
      "gas_used": 2552,
      "parameters": {
        "entrypoint": "execute",
        "value": {
          "action_name": "SetExpiry",
          "original_sender": "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
          "payload":
              "0507070a0000000663726372746e07070a0000000374657a0509008a95a1e70c"
        }
      },
      "code_hash": "5befb75267e3402b",
      "sender": "KT1Mqx5meQbhufngJnUAGEGpa4ZRxhPSiCgB",
      "receiver": "KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS",
      "source": "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk",
      "confirmations": 1609572
    }
  ];

  setUp(() {
    mockApi = MockApi();
    sut = Transactions(mockApi);
  });

  test('field has default value', () async {
    expect(sut.items, []);
  });

  group('transactions', () {
    test('retrieve transactions for address calls the tezos api', () {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveTransactions(address))
          .thenAnswer((_) async => []);
      sut.retrieve(address);
      verify(() => mockApi.retrieveTransactions(address)).called(1);
    });

    test('retrieve transactions for address sets field', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      final mockApiAnswer = exampleTransactions;
      when(() => mockApi.retrieveTransactions(address))
          .thenAnswer((_) async => mockApiAnswer);
      await sut.retrieve(address);
      expect(sut.items, mockApiAnswer);
    });

    test('retrieve transactions notifies listeners', () async {
      final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
      when(() => mockApi.retrieveTransactions(address))
          .thenAnswer((_) async => exampleTransactions);
      var notified = false;
      sut.addListener(() {
        notified = true;
      });
      await sut.retrieve(address);
      expect(notified, true);
    });
  });

  test('retrieve transactions with API error sets field to empty list',
      () async {
    final invalidAddress = "tzffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    when(() => mockApi.retrieveTransactions(invalidAddress))
        .thenThrow(AssertionError("an API error has occurred"));
    await sut.retrieve(invalidAddress);
    expect(sut.items, []);
  });
}
