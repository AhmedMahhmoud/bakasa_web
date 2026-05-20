// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bakasa — Card Game';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageShortEn => 'EN';

  @override
  String get languageShortAr => 'AR';

  @override
  String get collectorEdition => 'COLLECTOR EDITION';

  @override
  String get productName => 'Bakasa Card Game — Collector Box';

  @override
  String get shortDescription =>
      'The offline party card game from the Bakasa universe — fast rounds, big laughs, and rules everyone can learn in one minute.';

  @override
  String get insideTheBox => 'Inside the box';

  @override
  String get boxContents =>
      'Premium tuck box, full playing card deck, quick-start rules leaflet, and a code for future digital perks.';

  @override
  String get priceNote => 'Limited launch edition';

  @override
  String get currencyEgp => 'EGP';

  @override
  String priceLabel(int price) {
    return 'EGP $price';
  }

  @override
  String get orderNow => 'ORDER NOW';

  @override
  String get howToPlay => 'HOW TO PLAY';

  @override
  String get quickVideoGuide => 'Quick video guide';

  @override
  String get howToPlayDescription =>
      'Watch a fast tutorial to understand the game flow, roles, and how to start in seconds.';

  @override
  String get howToPlayBakasa => 'How to play Bakasa';

  @override
  String get youtube => 'YouTube';

  @override
  String get connectWithUs => 'CONNECT WITH US';

  @override
  String get joinCommunityTitle => 'Join the Bakasa community';

  @override
  String get joinCommunityDescription =>
      'Follow updates, download the app, and reach us directly.';

  @override
  String get socialGooglePlay => 'Google Play';

  @override
  String get socialAppStore => 'App Store';

  @override
  String get socialInstagram => 'Instagram';

  @override
  String get socialFacebook => 'Facebook';

  @override
  String get socialTikTok => 'TikTok';

  @override
  String get emailSubjectContactUs => 'Bakasa - Contact us';

  @override
  String get placeYourOrder => 'Place your order';

  @override
  String get deliveryDetailsIntro =>
      'We need a few details to arrange delivery.';

  @override
  String get fullName => 'Full name';

  @override
  String get validatorEnterName => 'Please enter your name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneHint => 'e.g. +20 10 1234 5678';

  @override
  String get validatorEnterPhone => 'Please enter your phone number';

  @override
  String get validatorPhoneInvalid => 'Enter a valid phone number';

  @override
  String get governorate => 'Governorate';

  @override
  String get validatorSelectGovernorate => 'Select your governorate';

  @override
  String get city => 'City / area';

  @override
  String get validatorEnterCity => 'Please enter your city / area';

  @override
  String get streetName => 'Street name';

  @override
  String get validatorEnterStreet => 'Please enter street name';

  @override
  String get buildingNumber => 'Building no.';

  @override
  String get floorNumber => 'Floor no.';

  @override
  String get apartmentNumber => 'Apartment no.';

  @override
  String get validatorRequired => 'Required';

  @override
  String get validatorEnterApartment => 'Please enter apartment number';

  @override
  String get notesLandmarkOptional => 'Notes / landmark (optional)';

  @override
  String get locating => 'Locating…';

  @override
  String get useMyCurrentLocation => 'Use my current location';

  @override
  String get locationHelp =>
      'Uses GPS to suggest a nearby address for notes / landmark. Please still fill exact street, building, floor, and apartment.';

  @override
  String get submitOrder => 'SUBMIT ORDER';

  @override
  String get errorLocationServicesOff =>
      'Turn on location services to use this.';

  @override
  String get errorLocationPermissionRequired =>
      'Location permission is required to detect your address.';

  @override
  String get errorLookupAddress =>
      'Could not look up your address. Please type it manually.';

  @override
  String errorGetLocation(String error) {
    return 'Could not get location: $error';
  }

  @override
  String get errorSomethingWentWrong => 'Something went wrong. Try again.';

  @override
  String orderInfoEmailOnly(String email) {
    return 'Orders are sent by email to $email (SMTP in the app on phone/desktop; on web your mail app opens). Optional: set firebaseOrderSubmitUrl to POST to your own server instead.';
  }

  @override
  String orderInfoPost(String email) {
    return 'Orders POST to your configured URL; a copy may also be emailed to $email.';
  }

  @override
  String get promoCode => 'Promo code';

  @override
  String get promoCodeIntro =>
      'Have a partner code? Apply it before you submit — we’ll check it live.';

  @override
  String get enterYourPromoCode => 'Enter your promo code';

  @override
  String get apply => 'Apply';

  @override
  String get appliedLabel => 'Applied: ';

  @override
  String percentOff(int percent) {
    return '$percent% off';
  }

  @override
  String get remove => 'Remove';

  @override
  String get collectorBoxPrice => 'Collector box · price';

  @override
  String get promoNoPercent =>
      'Promo applied — this code has no % discount, so the list price applies.';

  @override
  String youSave(String currency, int amount, int percent, String code) {
    return 'You save $currency $amount · $percent% off ($code).';
  }

  @override
  String percentOffApplied(int percent, String code) {
    return '$percent% off applied ($code).';
  }

  @override
  String get promoErrorEmpty => 'Enter a code or leave this section blank.';

  @override
  String get promoErrorEnter => 'Enter a promo code';

  @override
  String get promoErrorCouldNotApply => 'Could not apply this code.';

  @override
  String get promoErrorNotValid => 'This promo code isn’t valid.';

  @override
  String get promoErrorNotActive => 'This promo code isn’t active anymore.';

  @override
  String get promoErrorExpired => 'This promo code has expired (fully used).';

  @override
  String get promoErrorTooLong => 'That code is too long.';

  @override
  String get promoErrorNeedsFirebase =>
      'Promo codes need Firebase. Open the web app build (Flutter web).';

  @override
  String promoErrorValidation(String code) {
    return 'Could not validate the code ($code). Try again.';
  }

  @override
  String get orderTotal => 'Order total';

  @override
  String get item => 'Item';

  @override
  String get delivery => 'Delivery';

  @override
  String get selectGovernorateShort => 'Select governorate';

  @override
  String get total => 'Total';

  @override
  String currencyAmount(String currency, int amount) {
    return '$currency $amount';
  }

  @override
  String get orderReceived => 'Order received!';

  @override
  String get orderReceivedDescription =>
      'Thanks for choosing Bakasa. Our team will reach out soon to confirm your order and delivery details.';

  @override
  String get backToProduct => 'BACK TO PRODUCT';

  @override
  String get governorateIsmailia => 'Ismailia';

  @override
  String get governorateAswan => 'Aswan';

  @override
  String get governorateLuxor => 'Luxor';

  @override
  String get governorateAlexandria => 'Alexandria';

  @override
  String get governorateAsyut => 'Asyut';

  @override
  String get governorateSharqia => 'Sharqia';

  @override
  String get governorateRedSea => 'Red Sea';

  @override
  String get governorateBeheira => 'Beheira';

  @override
  String get governorateGiza => 'Giza';

  @override
  String get governorateSuez => 'Suez';

  @override
  String get governorateDakahlia => 'Dakahlia';

  @override
  String get governorateFayoum => 'Fayoum';

  @override
  String get governorateCairo => 'Cairo';

  @override
  String get governorateQalyubia => 'Qalyubia';

  @override
  String get governorateMinya => 'Minya';

  @override
  String get governorateBeniSuef => 'Beni Suef';

  @override
  String get governorateMonufia => 'Monufia';

  @override
  String get governoratePortSaid => 'Port Said';

  @override
  String get governorateNewValley => 'New Valley';

  @override
  String get governorateGharbia => 'Gharbia';

  @override
  String get governorateSouthSinai => 'South Sinai';

  @override
  String get governorateNorthSinai => 'North Sinai';

  @override
  String get governorateDamietta => 'Damietta';

  @override
  String get governorateSohag => 'Sohag';

  @override
  String get governorateQena => 'Qena';

  @override
  String get governorateKafrElSheikh => 'Kafr El Sheikh';

  @override
  String get governorateMatrouh => 'Matrouh';
}
