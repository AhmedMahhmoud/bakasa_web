import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user-selected app [Locale], persists it across launches, and
/// notifies listeners on change.
///
/// Defaults to Arabic for all first-time users; the device locale is ignored.
class LocaleController extends ChangeNotifier {
  LocaleController._(this._locale);

  static const String _prefsKey = 'bakasa.locale';

  /// Locales the app ships translations for.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar', 'EG'),
  ];

  static const Locale englishLocale = Locale('en');
  static const Locale arabicLocale = Locale('ar', 'EG');

  Locale _locale;
  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  /// Loads the persisted locale (if any); otherwise falls back to Arabic.
  static Future<LocaleController> load() async {
    Locale? stored;
    try {
      final prefs = await SharedPreferences.getInstance();
      stored = _decode(prefs.getString(_prefsKey));
    } catch (_) {
      // Fall through to default — never block app start on storage errors.
      stored = null;
    }
    return LocaleController._(stored ?? defaultLocaleForDevice());
  }

  /// Test-/fallback-friendly synchronous constructor. Picks the default
  /// without touching storage; use [setLocale] later to persist.
  factory LocaleController.synchronous() {
    return LocaleController._(defaultLocaleForDevice());
  }

  /// Arabic-first defaulting: every new install starts in Arabic, regardless
  /// of the device's preferred languages. Users can switch via the language
  /// toggle, and that choice is what gets persisted.
  static Locale defaultLocaleForDevice() => arabicLocale;

  Future<void> setLocale(Locale next) async {
    final normalized = _normalize(next);
    if (_localesEqual(_locale, normalized)) return;
    _locale = normalized;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _encode(normalized));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LocaleController: failed to persist locale ($e)');
      }
    }
  }

  /// Convenience: flip between English and Arabic.
  Future<void> toggle() => setLocale(isArabic ? englishLocale : arabicLocale);

  // ---- helpers ----

  static Locale _normalize(Locale l) {
    switch (l.languageCode) {
      case 'ar':
        return arabicLocale;
      case 'en':
        return englishLocale;
      default:
        return englishLocale;
    }
  }

  static String _encode(Locale l) {
    final country = l.countryCode;
    if (country == null || country.isEmpty) return l.languageCode;
    return '${l.languageCode}_$country';
  }

  static Locale? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('_');
    final lang = parts[0];
    if (lang != 'en' && lang != 'ar') return null;
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return Locale(lang, parts[1]);
    }
    return Locale(lang);
  }

  static bool _localesEqual(Locale a, Locale b) =>
      a.languageCode == b.languageCode && a.countryCode == b.countryCode;
}

/// Inherited access point. Rebuilds dependents when the controller notifies.
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope is missing above this widget.');
    return scope!.notifier!;
  }
}
