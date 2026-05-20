import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bakasa_web/main.dart';
import 'package:bakasa_web/services/locale_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Product page loads with order CTA (English)',
      (WidgetTester tester) async {
    final controller = LocaleController.synchronous();
    await controller.setLocale(LocaleController.englishLocale);

    await tester.pumpWidget(BakasaApp(localeController: controller));
    await tester.pump();

    expect(find.textContaining('ORDER NOW'), findsOneWidget);
    expect(find.textContaining('Bakasa'), findsWidgets);
  });

  testWidgets('Switches to Arabic and renders RTL', (WidgetTester tester) async {
    final controller = LocaleController.synchronous();
    await controller.setLocale(LocaleController.arabicLocale);

    await tester.pumpWidget(BakasaApp(localeController: controller));
    await tester.pump();

    // Arabic copy for "ORDER NOW".
    final orderNow = find.textContaining('اطلبها');
    expect(orderNow, findsOneWidget);
    // Subtree below MaterialApp should be RTL when locale is Arabic.
    final dir = Directionality.of(tester.element(orderNow));
    expect(dir, TextDirection.rtl);
  });
}
