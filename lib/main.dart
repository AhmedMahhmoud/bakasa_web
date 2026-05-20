import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/screens/product_screen.dart';
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
  runApp(const BakasaApp());
  splash.removeWebSplashAfterFirstFrame();
}

class BakasaApp extends StatelessWidget {
  const BakasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BakasaConfig.appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildBakasaTheme(),
      home: const ProductScreen(),
    );
  }
}
