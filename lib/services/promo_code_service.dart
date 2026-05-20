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

/// Reason code returned from [PromoCodeService.validate] when validation fails.
/// The UI maps each code to a localized string so error messages stay in the
/// current app language.
enum PromoErrorCode {
  needsFirebase,
  empty,
  tooLong,
  notFound,
  notActive,
  expired,
  validationFailed,
}

class PromoValidationResult {
  const PromoValidationResult.success(this.promo)
      : errorCode = null,
        errorContext = null;

  const PromoValidationResult.failure(
    PromoErrorCode code, {
    this.errorContext,
  })  : promo = null,
        errorCode = code;

  final ValidatedPromo? promo;
  final PromoErrorCode? errorCode;

  /// Optional extra detail (e.g. Firebase error code) for codes that template
  /// it into their message.
  final String? errorContext;

  bool get ok => errorCode == null && promo != null;
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

  static Future<PromoValidationResult> validate(String raw) async {
    if (Firebase.apps.isEmpty) {
      return const PromoValidationResult.failure(PromoErrorCode.needsFirebase);
    }

    final normalized = normalize(raw);
    if (normalized.isEmpty) {
      return const PromoValidationResult.failure(PromoErrorCode.empty);
    }
    if (normalized.length > BakasaConfig.promoCodeMaxLength) {
      return const PromoValidationResult.failure(PromoErrorCode.tooLong);
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
        return const PromoValidationResult.failure(PromoErrorCode.notFound);
      }

      final doc = found.docs.single;
      final data = doc.data();

      final storedCodeRaw = data['code'];
      final promoId = storedCodeRaw is String
          ? normalize(storedCodeRaw)
          : normalized;

      if (!_readActive(data)) {
        return const PromoValidationResult.failure(PromoErrorCode.notActive);
      }

      final rawLabel = data['label'];
      final label = rawLabel is String && rawLabel.trim().isNotEmpty
          ? rawLabel.trim()
          : promoId;

      final pct = _readDiscountPercent(data);
      final qty = _readQuantity(data);
      if (qty <= 0) {
        return const PromoValidationResult.failure(PromoErrorCode.expired);
      }

      return PromoValidationResult.success(
        ValidatedPromo(
          id: promoId,
          label: label,
          discountPercent: pct,
          quantityLeft: qty,
        ),
      );
    } on FirebaseException catch (e) {
      return PromoValidationResult.failure(
        PromoErrorCode.validationFailed,
        errorContext: e.code,
      );
    } catch (_) {
      return const PromoValidationResult.failure(
        PromoErrorCode.validationFailed,
      );
    }
  }
}
