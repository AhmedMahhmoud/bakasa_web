import 'package:bakasa_web/l10n/app_localizations.dart';

/// Maps a governorate's canonical Arabic id (used as the key in
/// `BakasaConfig.deliveryCostByGovernorateEgp` and persisted with orders)
/// to its localized display name.
///
/// Falls back to the raw id if no mapping exists — that keeps unknown keys
/// readable instead of vanishing.
String governorateLabel(String arabicId, AppLocalizations l10n) {
  switch (arabicId) {
    case 'الإسماعيلية':
      return l10n.governorateIsmailia;
    case 'أسوان':
      return l10n.governorateAswan;
    case 'الأقصر':
      return l10n.governorateLuxor;
    case 'الإسكندرية':
      return l10n.governorateAlexandria;
    case 'أسيوط':
      return l10n.governorateAsyut;
    case 'الشرقية':
      return l10n.governorateSharqia;
    case 'البحر الأحمر':
      return l10n.governorateRedSea;
    case 'البحيرة':
      return l10n.governorateBeheira;
    case 'الجيزة':
      return l10n.governorateGiza;
    case 'السويس':
      return l10n.governorateSuez;
    case 'الدقهلية':
      return l10n.governorateDakahlia;
    case 'الفيوم':
      return l10n.governorateFayoum;
    case 'القاهرة':
      return l10n.governorateCairo;
    case 'القليوبية':
      return l10n.governorateQalyubia;
    case 'المنيا':
      return l10n.governorateMinya;
    case 'بني سويف':
      return l10n.governorateBeniSuef;
    case 'المنوفية':
      return l10n.governorateMonufia;
    case 'بورسعيد':
      return l10n.governoratePortSaid;
    case 'الوادي الجديد':
      return l10n.governorateNewValley;
    case 'الغربية':
      return l10n.governorateGharbia;
    case 'جنوب سيناء':
      return l10n.governorateSouthSinai;
    case 'شمال سيناء':
      return l10n.governorateNorthSinai;
    case 'دمياط':
      return l10n.governorateDamietta;
    case 'سوهاج':
      return l10n.governorateSohag;
    case 'قنا':
      return l10n.governorateQena;
    case 'كفر الشيخ':
      return l10n.governorateKafrElSheikh;
    case 'مطروح':
      return l10n.governorateMatrouh;
    default:
      return arabicId;
  }
}
