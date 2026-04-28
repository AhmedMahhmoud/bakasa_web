import 'package:bakasa_web/config.dart';
import 'package:bakasa_web/screens/product_screen.dart';
import 'package:bakasa_web/theme/bakasa_theme.dart';
import 'package:flutter/material.dart';

import 'splash_stub.dart' if (dart.library.js_interop) 'splash_web.dart' as splash;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
