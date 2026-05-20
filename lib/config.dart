import 'dart:convert';

/// Product copy and integration settings.
///
/// **Orders / email:** With an empty [firebaseOrderSubmitUrl], orders go by email only
/// (SMTP + [mailer] on mobile/desktop; mailto on web). Optional: set [firebaseOrderSubmitUrl]
/// to `POST` JSON to any HTTPS backend (e.g. Firebase `submitOrder` in `functions/index.js`).
/// Secrets in this file ship in the app bundle / compiled JS.
class BakasaConfig {
  BakasaConfig._();

  static const String appTitle = 'Bakasa — Card Game';

  /// Replace `assets/images/game_logo.png` with your exported logo (PNG/WebP).
  static const String gameLogoAsset = 'assets/images/game_logo.png';
  static const List<String> heroSliderAssets = <String>[
    'assets/images/hero_slider/hero_1.png',
    'assets/images/hero_slider/hero_2.png',
    // 'assets/images/hero_slider/hero_3.png',
    'assets/images/hero_slider/hero_4.png',
    'assets/images/hero_slider/hero_5.png',
    'assets/images/hero_slider/hero_6.png',
    'assets/images/hero_slider/hero_7.png',
  ];

  /// Firestore collection for promo codes. Each doc should have string field `code`
  /// (doc ids can be auto-generated). See `firestore/seed_promo_codes.txt`.
  static const String promoCodesFirestoreCollection = 'promo_codes';

  /// Max length after trimming / lowercasing (keep codes short).
  static const int promoCodeMaxLength = 48;

  static const String productName = 'Bakasa Card Game — Collector Box';

  /// Base list price for one box in EGP. Keep in sync with [priceLabel].
  static const int productPriceEgp = 250;

  static const String priceCurrency = 'EGP';
  static const String priceLabel = 'EGP 250';
  static const String priceNote = 'Limited launch edition';

  /// Delivery fee by governorate in EGP.
  static const Map<String, int> deliveryCostByGovernorateEgp = <String, int>{
    'الإسماعيلية': 75,
    'أسوان': 110,
    'الأقصر': 110,
    'الإسكندرية': 70,
    'أسيوط': 80,
    'الشرقية': 70,
    'البحر الأحمر': 110,
    'البحيرة': 70,
    'الجيزة': 60,
    'السويس': 75,
    'الدقهلية': 70,
    'الفيوم': 80,
    'القاهرة': 60,
    'القليوبية': 60,
    'المنيا': 80,
    'بني سويف': 80,
    'المنوفية': 70,
    'بورسعيد': 75,
    'الوادي الجديد': 120,
    'الغربية': 70,
    'جنوب سيناء': 120,
    'شمال سيناء': 120,
    'دمياط': 70,
    'سوهاج': 110,
    'قنا': 110,
    'كفر الشيخ': 70,
    'مطروح': 120,
  };

  static const String shortDescription =
      'The offline party card game from the Bakasa universe — fast rounds, big laughs, '
      'and rules everyone can learn in one minute.';

  static const String boxContents =
      'Premium tuck box, full playing card deck, quick-start rules leaflet, '
      'and a code for future digital perks.';

  static const String orderEmail = 'bakasagame@gmail.com';

  /// Gmail **app password** (Google Account → Security → App passwords), not your normal
  /// login password. Used only for in-app SMTP on mobile/desktop ([mailer]).
  ///
  /// Set this **or** [orderSmtpAppPasswordBase64] (plain wins if both are non-empty).
  /// Leave both empty to skip client-side SMTP. Credentials ship inside the app binary.
  static const String orderSmtpAppPassword = 'wtopbljgwiuwtfjs';

  /// Same secret as [orderSmtpAppPassword], but stored as Base64(UTF-8) for light
  /// obfuscation in source control. Generate: `printf '%s' 'YOUR_APP_PASSWORD' | base64`
  static const String orderSmtpAppPasswordBase64 = '';

  /// Resolved SMTP password for [mailer], or `null` if neither field is set / Base64 is invalid.
  static String? get orderSmtpPasswordResolved {
    final plain = orderSmtpAppPassword.trim();
    if (plain.isNotEmpty) return plain;
    final encoded = orderSmtpAppPasswordBase64.trim();
    if (encoded.isEmpty) return null;
    try {
      return utf8.decode(base64Decode(encoded)).trim();
    } on FormatException {
      return null;
    }
  }

  /// HTTPS URL for Cloud Function `submitOrder` (2nd gen → Cloud Run style URL).
  static const String firebaseOrderSubmitUrl =
      'https://submitorder-jq5ewpfapa-uc.a.run.app';

  static const String _orderSubmitUrlEnv = String.fromEnvironment(
    'ORDER_SUBMIT_URL',
  );

  static String get orderSubmitUrlResolved {
    final fromEnv = _orderSubmitUrlEnv.trim();
    if (fromEnv.isNotEmpty) return fromEnv;
    return firebaseOrderSubmitUrl.trim();
  }

  /// Optional. If set in Cloud Function as `ORDER_FORM_SECRET`, same value must be sent
  /// from the app (here or `--dart-define=ORDER_FORM_SECRET=...`).
  static const String orderFormSecret = '';

  static const String _orderFormSecretEnv = String.fromEnvironment(
    'ORDER_FORM_SECRET',
  );

  static String get orderFormSecretResolved {
    final fromEnv = _orderFormSecretEnv.trim();
    if (fromEnv.isNotEmpty) return fromEnv;
    return orderFormSecret.trim();
  }

  /// Identifies this app for OpenStreetMap Nominatim (reverse geocoding). Required by their usage policy.
  static const String nominatimUserAgent =
      'BakasaWeb/1.0 (order form; contact: bakasagame@gmail.com)';
}
