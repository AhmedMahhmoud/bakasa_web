import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/screens/product_screen.dart';
import 'package:bakasa_web/services/locale_controller.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'splash_stub.dart'
    if (dart.library.js_interop) 'splash_web.dart'
    as splash;

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final localeController = await LocaleController.load();
  runApp(BakasaApp(localeController: localeController));
  splash.removeWebSplashAfterFirstFrame();
}

class BakasaApp extends StatefulWidget {
  const BakasaApp({super.key, this.localeController});

  /// Optional so widget tests can construct `BakasaApp()` without bootstrapping
  /// shared_preferences. When null, a synchronous controller is created.
  final LocaleController? localeController;

  @override
  State<BakasaApp> createState() => _BakasaAppState();
}

class _BakasaAppState extends State<BakasaApp> {
  late final LocaleController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.localeController == null;
    _controller = widget.localeController ?? LocaleController.synchronous();
    _controller.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onLocaleChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _controller,
      child: MaterialApp(
        onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
        debugShowCheckedModeBanner: false,
        theme: buildBakasaTheme(),
        locale: _controller.locale,
        supportedLocales: LocaleController.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // Anything outside our supported set (or null) collapses to the
        // controller's current locale — never an unsupported fallback.
        localeListResolutionCallback: (deviceLocales, supported) {
          return _controller.locale;
        },
        home: const ProductScreen(),
      ),
    );
  }
}
