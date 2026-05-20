// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بكاسة — لعبة الكروت';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageShortEn => 'EN';

  @override
  String get languageShortAr => 'ع';

  @override
  String get collectorEdition => 'الإصدار المحدود';

  @override
  String get productName => 'لعبة بكاسة — كارد جيم';

  @override
  String get shortDescription =>
      'لعبة الكروت الجماعية من عالم بكاسة — جولات سريعة، ضحك بلا توقف، وقواعد بسيطة يقدر أي حد يتعلمها في دقيقة واحدة.';

  @override
  String get insideTheBox => 'محتويات الصندوق';

  @override
  String get boxContents =>
      'محتويات اللعبة: ٤ كاتيجوريز مختلفة: عشوائيات، حيوانات، وظائف، وأماكن، بالإضافة إلى ١٥ كارت جوا اللعبة، و٥ كروت بره، وكارت الشرح.';

  @override
  String get priceNote => 'إصدار محدود بمناسبة الإطلاق';

  @override
  String get currencyEgp => 'ج.م';

  @override
  String priceLabel(int price) {
    return '$price ج.م';
  }

  @override
  String get orderNow => 'اطلبها الآن';

  @override
  String get howToPlay => 'طريقة اللعب';

  @override
  String get quickVideoGuide => 'شرح سريع بالفيديو';

  @override
  String get howToPlayDescription =>
      'اتفرّج على شرح سريع تعرف منه طريقة اللعب والأدوار وإزاي تبدأ في ثواني.';

  @override
  String get howToPlayBakasa => 'إزاي تلعب بكاسة';

  @override
  String get youtube => 'يوتيوب';

  @override
  String get connectWithUs => 'تواصل معانا';

  @override
  String get joinCommunityTitle => 'انضم لمجتمع بكاسة';

  @override
  String get joinCommunityDescription =>
      'تابع كل جديد، حمّل التطبيق، وتواصل معانا مباشرة.';

  @override
  String get socialGooglePlay => 'جوجل بلاي';

  @override
  String get socialAppStore => 'آب ستور';

  @override
  String get socialInstagram => 'إنستجرام';

  @override
  String get socialFacebook => 'فيسبوك';

  @override
  String get socialTikTok => 'تيك توك';

  @override
  String get emailSubjectContactUs => 'بكاسة - تواصل معانا';

  @override
  String get placeYourOrder => 'إتمام الطلب';

  @override
  String get deliveryDetailsIntro => 'محتاجين شوية بيانات عشان نوصّل طلبك.';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get validatorEnterName => 'من فضلك اكتب اسمك';

  @override
  String get phoneNumber => 'رقم الموبايل';

  @override
  String get phoneHint => 'مثال: 01012345678';

  @override
  String get validatorEnterPhone => 'من فضلك اكتب رقم موبايلك';

  @override
  String get validatorPhoneInvalid => 'اكتب رقم موبايل صحيح';

  @override
  String get governorate => 'المحافظة';

  @override
  String get validatorSelectGovernorate => 'اختر محافظتك';

  @override
  String get city => 'المدينة / المنطقة';

  @override
  String get validatorEnterCity => 'من فضلك اكتب المدينة / المنطقة';

  @override
  String get streetName => 'اسم الشارع';

  @override
  String get validatorEnterStreet => 'من فضلك اكتب اسم الشارع';

  @override
  String get buildingNumber => 'رقم العقار';

  @override
  String get floorNumber => 'رقم الدور';

  @override
  String get apartmentNumber => 'رقم الشقة';

  @override
  String get validatorRequired => 'مطلوب';

  @override
  String get validatorEnterApartment => 'من فضلك اكتب رقم الشقة';

  @override
  String get notesLandmarkOptional => 'ملاحظات / علامة مميزة (اختياري)';

  @override
  String get locating => 'بنحدّد موقعك…';

  @override
  String get useMyCurrentLocation => 'استخدم موقعي الحالي';

  @override
  String get locationHelp =>
      'بنستخدم GPS لاقتراح عنوان قريب كعلامة مميزة. من فضلك اكتب اسم الشارع ورقم العقار والدور والشقة بدقة.';

  @override
  String get submitOrder => 'إرسال الطلب';

  @override
  String get errorLocationServicesOff => 'فعّل خدمة الموقع عشان نقدر نستخدمها.';

  @override
  String get errorLocationPermissionRequired =>
      'محتاجين إذن الوصول للموقع عشان نكتشف عنوانك.';

  @override
  String get errorLookupAddress =>
      'ما قدرناش نجيب عنوانك. من فضلك اكتبه يدويًا.';

  @override
  String errorGetLocation(String error) {
    return 'ما قدرناش نجيب الموقع: $error';
  }

  @override
  String get errorSomethingWentWrong => 'حصلت مشكلة. حاول تاني.';

  @override
  String orderInfoEmailOnly(String email) {
    return 'الطلبات بتتبعت بالإيميل على $email (SMTP داخل التطبيق على الموبايل/الكمبيوتر؛ على الويب بيتفتح برنامج الإيميل عندك). اختياري: ضبط firebaseOrderSubmitUrl لإرسالها لسيرفرك.';
  }

  @override
  String orderInfoPost(String email) {
    return 'الطلبات بتتبعت لـ URL الـ POST المضبوط؛ وممكن نسخة كمان تتبعت على $email.';
  }

  @override
  String get promoCode => 'كود الخصم';

  @override
  String get promoCodeIntro =>
      'عندك كود من شريك؟ طبّقه قبل ما تبعت الطلب — هنتحقق منه فورًا.';

  @override
  String get enterYourPromoCode => 'اكتب كود الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get appliedLabel => 'مُفعّل: ';

  @override
  String percentOff(int percent) {
    return 'خصم $percent%';
  }

  @override
  String get remove => 'إزالة';

  @override
  String get collectorBoxPrice => 'الصندوق · السعر';

  @override
  String get promoNoPercent =>
      'الكود مُفعّل — لكن مفيش نسبة خصم، فالسعر هو الأساسي.';

  @override
  String youSave(String currency, int amount, int percent, String code) {
    return 'وفّرت $amount $currency · خصم $percent% ($code).';
  }

  @override
  String percentOffApplied(int percent, String code) {
    return 'تم تفعيل خصم $percent% ($code).';
  }

  @override
  String get promoErrorEmpty => 'اكتب كود أو سيب الخانة دي فاضية.';

  @override
  String get promoErrorEnter => 'اكتب كود خصم';

  @override
  String get promoErrorCouldNotApply => 'ما قدرناش نفعّل الكود ده.';

  @override
  String get promoErrorNotValid => 'الكود ده مش صحيح.';

  @override
  String get promoErrorNotActive => 'الكود ده مش مُفعّل دلوقتي.';

  @override
  String get promoErrorExpired => 'الكود ده انتهى (تم استخدامه بالكامل).';

  @override
  String get promoErrorTooLong => 'الكود طويل جدًا.';

  @override
  String get promoErrorNeedsFirebase =>
      'أكواد الخصم محتاجة Firebase. افتح نسخة الويب من التطبيق.';

  @override
  String promoErrorValidation(String code) {
    return 'ما قدرناش نتحقق من الكود ($code). حاول تاني.';
  }

  @override
  String get orderTotal => 'إجمالي الطلب';

  @override
  String get item => 'المنتج';

  @override
  String get delivery => 'التوصيل';

  @override
  String get selectGovernorateShort => 'اختر المحافظة';

  @override
  String get total => 'الإجمالي';

  @override
  String currencyAmount(String currency, int amount) {
    return '$amount $currency';
  }

  @override
  String get orderReceived => 'تم استلام طلبك!';

  @override
  String get orderReceivedDescription =>
      'شكرًا لاختيارك بكاسة. فريقنا هيتواصل معاك قريب جدًا لتأكيد الطلب وتفاصيل التوصيل.';

  @override
  String get backToProduct => 'الرجوع للمنتج';

  @override
  String get governorateIsmailia => 'الإسماعيلية';

  @override
  String get governorateAswan => 'أسوان';

  @override
  String get governorateLuxor => 'الأقصر';

  @override
  String get governorateAlexandria => 'الإسكندرية';

  @override
  String get governorateAsyut => 'أسيوط';

  @override
  String get governorateSharqia => 'الشرقية';

  @override
  String get governorateRedSea => 'البحر الأحمر';

  @override
  String get governorateBeheira => 'البحيرة';

  @override
  String get governorateGiza => 'الجيزة';

  @override
  String get governorateSuez => 'السويس';

  @override
  String get governorateDakahlia => 'الدقهلية';

  @override
  String get governorateFayoum => 'الفيوم';

  @override
  String get governorateCairo => 'القاهرة';

  @override
  String get governorateQalyubia => 'القليوبية';

  @override
  String get governorateMinya => 'المنيا';

  @override
  String get governorateBeniSuef => 'بني سويف';

  @override
  String get governorateMonufia => 'المنوفية';

  @override
  String get governoratePortSaid => 'بورسعيد';

  @override
  String get governorateNewValley => 'الوادي الجديد';

  @override
  String get governorateGharbia => 'الغربية';

  @override
  String get governorateSouthSinai => 'جنوب سيناء';

  @override
  String get governorateNorthSinai => 'شمال سيناء';

  @override
  String get governorateDamietta => 'دمياط';

  @override
  String get governorateSohag => 'سوهاج';

  @override
  String get governorateQena => 'قنا';

  @override
  String get governorateKafrElSheikh => 'كفر الشيخ';

  @override
  String get governorateMatrouh => 'مطروح';
}
