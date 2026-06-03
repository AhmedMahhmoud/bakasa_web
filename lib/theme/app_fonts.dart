import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Locally-bundled fonts that contain Arabic glyphs, used as a fallback chain.
///
/// The brand display/body fonts (Orbitron, Exo 2) are Latin-only — they have
/// no Arabic glyphs. Listing [Cairo] as a fallback means any Arabic character
/// resolves to the bundled Cairo font on the FIRST frame, with no network
/// round-trip. Without this, the web engine downloads a Noto Arabic fallback
/// on demand, so Arabic text flashes as tofu boxes (□) on first load.
const List<String> kArabicFallback = <String>['Cairo'];

/// Brand display font (Orbitron) with the Arabic fallback chain applied.
///
/// Drop-in replacement for `GoogleFonts.orbitron(...)`: same parameters, but the
/// returned style falls back to a bundled Arabic font for any glyph Orbitron
/// lacks. Latin text is unaffected (Orbitron covers it).
TextStyle appDisplayFont({
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  return GoogleFonts.orbitron(
    textStyle: textStyle,
    color: color,
    backgroundColor: backgroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    height: height,
    locale: locale,
    foreground: foreground,
    background: background,
    shadows: shadows,
    fontFeatures: fontFeatures,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  ).copyWith(fontFamilyFallback: kArabicFallback);
}

/// Brand body font (Exo 2) with the Arabic fallback chain applied.
///
/// Drop-in replacement for `GoogleFonts.exo2(...)`. See [appDisplayFont].
TextStyle appBodyFont({
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  return GoogleFonts.exo2(
    textStyle: textStyle,
    color: color,
    backgroundColor: backgroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    height: height,
    locale: locale,
    foreground: foreground,
    background: background,
    shadows: shadows,
    fontFeatures: fontFeatures,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  ).copyWith(fontFamilyFallback: kArabicFallback);
}

/// Builds the base body [TextTheme] (Exo 2) with the Arabic fallback applied to
/// every style, so default-styled `Text` widgets render Arabic correctly too.
TextTheme appBodyTextTheme(TextTheme base) {
  return GoogleFonts.exo2TextTheme(base).apply(fontFamilyFallback: kArabicFallback);
}
