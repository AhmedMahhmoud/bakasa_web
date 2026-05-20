import 'package:bakasa_web/l10n/app_localizations.dart';
import 'package:bakasa_web/services/promo_code_service.dart';

/// Translates a [PromoErrorCode] to a user-facing, localized string.
String promoErrorMessage(
  AppLocalizations l10n,
  PromoErrorCode code, {
  String? context,
}) {
  switch (code) {
    case PromoErrorCode.needsFirebase:
      return l10n.promoErrorNeedsFirebase;
    case PromoErrorCode.empty:
      return l10n.promoErrorEnter;
    case PromoErrorCode.tooLong:
      return l10n.promoErrorTooLong;
    case PromoErrorCode.notFound:
      return l10n.promoErrorNotValid;
    case PromoErrorCode.notActive:
      return l10n.promoErrorNotActive;
    case PromoErrorCode.expired:
      return l10n.promoErrorExpired;
    case PromoErrorCode.validationFailed:
      return l10n.promoErrorValidation(context ?? '');
  }
}
