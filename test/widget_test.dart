import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:blackjack_tracking/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const BlackJackTrackingApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
