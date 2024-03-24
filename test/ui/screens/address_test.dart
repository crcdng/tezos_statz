import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:tezos_statz/data/storage.dart';
import 'package:tezos_statz/model/address.dart';
import 'package:tezos_statz/ui/screens/address.dart';
import 'package:tezos_statz/ui/widgets/copyable_address.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
  });

  testWidgets("When an Address is retrieved it is shown as a copyable address",
      (widgetTester) async {
    final address = "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk";
    // when(() => mockStorage.storeItem(address)).thenAnswer((_) async => null);
    when(() => mockStorage.retrieveItem()).thenAnswer((_) async => address);
    await widgetTester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => Address(mockStorage),
        child: MaterialApp(
          home: Scaffold(
            body: AddressScreen(),
          ),
        ),
      ),
    );
    expect(
        find.byWidgetPredicate(
            (widget) => widget is CopyableAddress && widget.address == address),
        findsOne);
  });

  testWidgets("When no Address is retrieved there is no copyable address shown",
      (widgetTester) async {
    when(() => mockStorage.retrieveItem()).thenAnswer((_) async => "");
    await widgetTester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => Address(mockStorage),
        child: MaterialApp(
          home: Scaffold(
            body: AddressScreen(),
          ),
        ),
      ),
    );
    expect(find.byType(CopyableAddress), findsNothing);
  });
}
