import 'package:bakasa_web/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Result of validating a promo code document in Firestore.
class ValidatedPromo {
  const ValidatedPromo({
    required this.id,
    required this.label,
    required this.discountPercent,
    required this.quantityLeft,
  });

  /// Normalized promo **code** (matches Firestore field `code`, not necessarily the doc id).
  final String id;
  final String label;

  /// Whole percent, e.g. 10 for "10%". May be 0 if not set in Firestore.
  final int discountPercent;
  final int quantityLeft;
}

/// Looks up documents in [BakasaConfig.promoCodesFirestoreCollection] by field `code`
/// trying trimmed input plus lower/upper variants (Firestore `==` is case-sensitive).
class PromoCodeService {
  PromoCodeService._();

  static String normalize(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');

  /// Firestore `==` is case-sensitive. Try trimmed input, lowercase, uppercase.
  static List<String> _queryCandidates(String raw) {
    final trimmed = raw.trim();
    final lower = normalize(raw);
    final upper =
        lower.isEmpty ? '' : lower.toUpperCase(); // ASCII promos typical
    final out = <String>[];
    void add(String s) {
      if (s.isEmpty || s.length > BakasaConfig.promoCodeMaxLength) return;
      if (!out.contains(s)) out.add(s);
    }

    add(trimmed);
    add(lower);
    add(upper);
    return out;
  }

  static int _readDiscountPercent(Map<String, dynamic> data) {
    final v = data['discount_percent'] ?? data['discountPercent'];
    if (v is int) return v;
    if (v is double) return v.round();
    return 0;
  }

  static bool _readActive(Map<String, dynamic> data) {
    if (data['active'] == false) return false;
    return true;
  }

  static int _readQuantity(Map<String, dynamic> data) {
    final v = data['quantity'];
    if (v is int) return v;
    if (v is double) return v.round();
    return 0;
  }

  static Future<({bool ok, ValidatedPromo? promo, String? error})> validate(
    String raw,
  ) async {
    if (Firebase.apps.isEmpty) {
      return (
        ok: false,
        promo: null,
        error:
            'Promo codes need Firebase. Open the web app build (Flutter web).',
      );
    }

    final normalized = normalize(raw);
    if (normalized.isEmpty) {
      return (ok: false, promo: null, error: 'Enter a promo code');
    }
    if (normalized.length > BakasaConfig.promoCodeMaxLength) {
      return (ok: false, promo: null, error: 'That code is too long.');
    }

    try {
      QuerySnapshot<Map<String, dynamic>>? found;
      for (final candidate in _queryCandidates(raw)) {
        final snapshot = await FirebaseFirestore.instance
            .collection(BakasaConfig.promoCodesFirestoreCollection)
            .where('code', isEqualTo: candidate)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          found = snapshot;
          break;
        }
      }

      if (found == null || found.docs.isEmpty) {
        return (ok: false, promo: null, error: 'This promo code isn’t valid.');
      }

      final doc = found.docs.single;
      final data = doc.data();

      final storedCodeRaw = data['code'];
      final promoId = storedCodeRaw is String
          ? normalize(storedCodeRaw)
          : normalized;

      if (!_readActive(data)) {
        return (
          ok: false,
          promo: null,
          error: 'This promo code isn’t active anymore.',
        );
      }

      final rawLabel = data['label'];
      final label = rawLabel is String && rawLabel.trim().isNotEmpty
          ? rawLabel.trim()
          : promoId;

      final pct = _readDiscountPercent(data);
      final qty = _readQuantity(data);
      if (qty <= 0) {
        return (
          ok: false,
          promo: null,
          error: 'This promo code has expired (fully used).',
        );
      }

      return (
        ok: true,
        promo: ValidatedPromo(
          id: promoId,
          label: label,
          discountPercent: pct,
          quantityLeft: qty,
        ),
        error: null,
      );
    } on FirebaseException catch (e) {
      return (
        ok: false,
        promo: null,
        error: 'Could not validate the code (${e.code}). Try again.',
      );
    } catch (_) {
      return (
        ok: false,
        promo: null,
        error: 'Something went wrong. Try again.',
      );
    }
  }
}
