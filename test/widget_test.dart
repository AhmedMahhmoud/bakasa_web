import 'package:flutter_test/flutter_test.dart';

import 'package:bakasa_web/main.dart';

void main() {
  testWidgets('Product page loads with order CTA', (WidgetTester tester) async {
    await tester.pumpWidget(const BakasaApp());
    await tester.pump();
    expect(find.textContaining('ORDER NOW'), findsOneWidget);
    expect(find.textContaining('Bakasa'), findsWidgets);
  });
}
