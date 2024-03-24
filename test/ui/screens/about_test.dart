import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezos_statz/ui/screens/about.dart';
import 'package:tezos_statz/ui/widgets/copyable_address.dart';

void main() {
  testWidgets("Tezos address is on page", (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AboutScreen(),
        ),
      ),
    );
    expect(
        find.byWidgetPredicate((widget) =>
            widget is CopyableAddress &&
            widget.address == "tz1ffYDwFHchNy5vA5isuCAK2yVxh4Ye9pnk"),
        findsOne);
  });
}
