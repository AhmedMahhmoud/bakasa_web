import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bakasa — Card Game'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageShortEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageShortEn;

  /// No description provided for @languageShortAr.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get languageShortAr;

  /// No description provided for @collectorEdition.
  ///
  /// In en, this message translates to:
  /// **'COLLECTOR EDITION'**
  String get collectorEdition;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Bakasa Card Game — Collector Box'**
  String get productName;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'The offline party card game from the Bakasa universe — fast rounds, big laughs, and rules everyone can learn in one minute.'**
  String get shortDescription;

  /// No description provided for @insideTheBox.
  ///
  /// In en, this message translates to:
  /// **'Inside the box'**
  String get insideTheBox;

  /// No description provided for @boxContents.
  ///
  /// In en, this message translates to:
  /// **'Premium tuck box, full playing card deck, quick-start rules leaflet, and a code for future digital perks.'**
  String get boxContents;

  /// No description provided for @priceNote.
  ///
  /// In en, this message translates to:
  /// **'Limited launch edition'**
  String get priceNote;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEgp;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'EGP {price}'**
  String priceLabel(int price);

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'ORDER NOW'**
  String get orderNow;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY'**
  String get howToPlay;

  /// No description provided for @quickVideoGuide.
  ///
  /// In en, this message translates to:
  /// **'Quick video guide'**
  String get quickVideoGuide;

  /// No description provided for @howToPlayDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch a fast tutorial to understand the game flow, roles, and how to start in seconds.'**
  String get howToPlayDescription;

  /// No description provided for @howToPlayBakasa.
  ///
  /// In en, this message translates to:
  /// **'How to play Bakasa'**
  String get howToPlayBakasa;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @connectWithUs.
  ///
  /// In en, this message translates to:
  /// **'CONNECT WITH US'**
  String get connectWithUs;

  /// No description provided for @joinCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Join the Bakasa community'**
  String get joinCommunityTitle;

  /// No description provided for @joinCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow updates, download the app, and reach us directly.'**
  String get joinCommunityDescription;

  /// No description provided for @socialGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get socialGooglePlay;

  /// No description provided for @socialAppStore.
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get socialAppStore;

  /// No description provided for @socialInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get socialInstagram;

  /// No description provided for @socialFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get socialFacebook;

  /// No description provided for @socialTikTok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get socialTikTok;

  /// No description provided for @emailSubjectContactUs.
  ///
  /// In en, this message translates to:
  /// **'Bakasa - Contact us'**
  String get emailSubjectContactUs;

  /// No description provided for @placeYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Place your order'**
  String get placeYourOrder;

  /// No description provided for @deliveryDetailsIntro.
  ///
  /// In en, this message translates to:
  /// **'We need a few details to arrange delivery.'**
  String get deliveryDetailsIntro;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @validatorEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validatorEnterName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. +20 10 1234 5678'**
  String get phoneHint;

  /// No description provided for @validatorEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get validatorEnterPhone;

  /// No description provided for @validatorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validatorPhoneInvalid;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @validatorSelectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select your governorate'**
  String get validatorSelectGovernorate;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City / area'**
  String get city;

  /// No description provided for @validatorEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city / area'**
  String get validatorEnterCity;

  /// No description provided for @streetName.
  ///
  /// In en, this message translates to:
  /// **'Street name'**
  String get streetName;

  /// No description provided for @validatorEnterStreet.
  ///
  /// In en, this message translates to:
  /// **'Please enter street name'**
  String get validatorEnterStreet;

  /// No description provided for @buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building no.'**
  String get buildingNumber;

  /// No description provided for @floorNumber.
  ///
  /// In en, this message translates to:
  /// **'Floor no.'**
  String get floorNumber;

  /// No description provided for @apartmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Apartment no.'**
  String get apartmentNumber;

  /// No description provided for @validatorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validatorRequired;

  /// No description provided for @validatorEnterApartment.
  ///
  /// In en, this message translates to:
  /// **'Please enter apartment number'**
  String get validatorEnterApartment;

  /// No description provided for @notesLandmarkOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes / landmark (optional)'**
  String get notesLandmarkOptional;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locating;

  /// No description provided for @useMyCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useMyCurrentLocation;

  /// No description provided for @locationHelp.
  ///
  /// In en, this message translates to:
  /// **'Uses GPS to suggest a nearby address for notes / landmark. Please still fill exact street, building, floor, and apartment.'**
  String get locationHelp;

  /// No description provided for @submitOrder.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT ORDER'**
  String get submitOrder;

  /// No description provided for @errorLocationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services to use this.'**
  String get errorLocationServicesOff;

  /// No description provided for @errorLocationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to detect your address.'**
  String get errorLocationPermissionRequired;

  /// No description provided for @errorLookupAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not look up your address. Please type it manually.'**
  String get errorLookupAddress;

  /// No description provided for @errorGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not get location: {error}'**
  String errorGetLocation(String error);

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorSomethingWentWrong;

  /// No description provided for @orderInfoEmailOnly.
  ///
  /// In en, this message translates to:
  /// **'Orders are sent by email to {email} (SMTP in the app on phone/desktop; on web your mail app opens). Optional: set firebaseOrderSubmitUrl to POST to your own server instead.'**
  String orderInfoEmailOnly(String email);

  /// No description provided for @orderInfoPost.
  ///
  /// In en, this message translates to:
  /// **'Orders POST to your configured URL; a copy may also be emailed to {email}.'**
  String orderInfoPost(String email);

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get promoCode;

  /// No description provided for @promoCodeIntro.
  ///
  /// In en, this message translates to:
  /// **'Have a partner code? Apply it before you submit — we’ll check it live.'**
  String get promoCodeIntro;

  /// No description provided for @enterYourPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your promo code'**
  String get enterYourPromoCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @appliedLabel.
  ///
  /// In en, this message translates to:
  /// **'Applied: '**
  String get appliedLabel;

  /// No description provided for @percentOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String percentOff(int percent);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @collectorBoxPrice.
  ///
  /// In en, this message translates to:
  /// **'Collector box · price'**
  String get collectorBoxPrice;

  /// No description provided for @promoNoPercent.
  ///
  /// In en, this message translates to:
  /// **'Promo applied — this code has no % discount, so the list price applies.'**
  String get promoNoPercent;

  /// No description provided for @youSave.
  ///
  /// In en, this message translates to:
  /// **'You save {currency} {amount} · {percent}% off ({code}).'**
  String youSave(String currency, int amount, int percent, String code);

  /// No description provided for @percentOffApplied.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off applied ({code}).'**
  String percentOffApplied(int percent, String code);

  /// No description provided for @promoErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a code or leave this section blank.'**
  String get promoErrorEmpty;

  /// No description provided for @promoErrorEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter a promo code'**
  String get promoErrorEnter;

  /// No description provided for @promoErrorCouldNotApply.
  ///
  /// In en, this message translates to:
  /// **'Could not apply this code.'**
  String get promoErrorCouldNotApply;

  /// No description provided for @promoErrorNotValid.
  ///
  /// In en, this message translates to:
  /// **'This promo code isn’t valid.'**
  String get promoErrorNotValid;

  /// No description provided for @promoErrorNotActive.
  ///
  /// In en, this message translates to:
  /// **'This promo code isn’t active anymore.'**
  String get promoErrorNotActive;

  /// No description provided for @promoErrorExpired.
  ///
  /// In en, this message translates to:
  /// **'This promo code has expired (fully used).'**
  String get promoErrorExpired;

  /// No description provided for @promoErrorTooLong.
  ///
  /// In en, this message translates to:
  /// **'That code is too long.'**
  String get promoErrorTooLong;

  /// No description provided for @promoErrorNeedsFirebase.
  ///
  /// In en, this message translates to:
  /// **'Promo codes need Firebase. Open the web app build (Flutter web).'**
  String get promoErrorNeedsFirebase;

  /// No description provided for @promoErrorValidation.
  ///
  /// In en, this message translates to:
  /// **'Could not validate the code ({code}). Try again.'**
  String promoErrorValidation(String code);

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get orderTotal;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @selectGovernorateShort.
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get selectGovernorateShort;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @currencyAmount.
  ///
  /// In en, this message translates to:
  /// **'{currency} {amount}'**
  String currencyAmount(String currency, int amount);

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'Order received!'**
  String get orderReceived;

  /// No description provided for @orderReceivedDescription.
  ///
  /// In en, this message translates to:
  /// **'Thanks for choosing Bakasa. Our team will reach out soon to confirm your order and delivery details.'**
  String get orderReceivedDescription;

  /// No description provided for @backToProduct.
  ///
  /// In en, this message translates to:
  /// **'BACK TO PRODUCT'**
  String get backToProduct;

  /// No description provided for @governorateIsmailia.
  ///
  /// In en, this message translates to:
  /// **'Ismailia'**
  String get governorateIsmailia;

  /// No description provided for @governorateAswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get governorateAswan;

  /// No description provided for @governorateLuxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get governorateLuxor;

  /// No description provided for @governorateAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get governorateAlexandria;

  /// No description provided for @governorateAsyut.
  ///
  /// In en, this message translates to:
  /// **'Asyut'**
  String get governorateAsyut;

  /// No description provided for @governorateSharqia.
  ///
  /// In en, this message translates to:
  /// **'Sharqia'**
  String get governorateSharqia;

  /// No description provided for @governorateRedSea.
  ///
  /// In en, this message translates to:
  /// **'Red Sea'**
  String get governorateRedSea;

  /// No description provided for @governorateBeheira.
  ///
  /// In en, this message translates to:
  /// **'Beheira'**
  String get governorateBeheira;

  /// No description provided for @governorateGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get governorateGiza;

  /// No description provided for @governorateSuez.
  ///
  /// In en, this message translates to:
  /// **'Suez'**
  String get governorateSuez;

  /// No description provided for @governorateDakahlia.
  ///
  /// In en, this message translates to:
  /// **'Dakahlia'**
  String get governorateDakahlia;

  /// No description provided for @governorateFayoum.
  ///
  /// In en, this message translates to:
  /// **'Fayoum'**
  String get governorateFayoum;

  /// No description provided for @governorateCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get governorateCairo;

  /// No description provided for @governorateQalyubia.
  ///
  /// In en, this message translates to:
  /// **'Qalyubia'**
  String get governorateQalyubia;

  /// No description provided for @governorateMinya.
  ///
  /// In en, this message translates to:
  /// **'Minya'**
  String get governorateMinya;

  /// No description provided for @governorateBeniSuef.
  ///
  /// In en, this message translates to:
  /// **'Beni Suef'**
  String get governorateBeniSuef;

  /// No description provided for @governorateMonufia.
  ///
  /// In en, this message translates to:
  /// **'Monufia'**
  String get governorateMonufia;

  /// No description provided for @governoratePortSaid.
  ///
  /// In en, this message translates to:
  /// **'Port Said'**
  String get governoratePortSaid;

  /// No description provided for @governorateNewValley.
  ///
  /// In en, this message translates to:
  /// **'New Valley'**
  String get governorateNewValley;

  /// No description provided for @governorateGharbia.
  ///
  /// In en, this message translates to:
  /// **'Gharbia'**
  String get governorateGharbia;

  /// No description provided for @governorateSouthSinai.
  ///
  /// In en, this message translates to:
  /// **'South Sinai'**
  String get governorateSouthSinai;

  /// No description provided for @governorateNorthSinai.
  ///
  /// In en, this message translates to:
  /// **'North Sinai'**
  String get governorateNorthSinai;

  /// No description provided for @governorateDamietta.
  ///
  /// In en, this message translates to:
  /// **'Damietta'**
  String get governorateDamietta;

  /// No description provided for @governorateSohag.
  ///
  /// In en, this message translates to:
  /// **'Sohag'**
  String get governorateSohag;

  /// No description provided for @governorateQena.
  ///
  /// In en, this message translates to:
  /// **'Qena'**
  String get governorateQena;

  /// No description provided for @governorateKafrElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Kafr El Sheikh'**
  String get governorateKafrElSheikh;

  /// No description provided for @governorateMatrouh.
  ///
  /// In en, this message translates to:
  /// **'Matrouh'**
  String get governorateMatrouh;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
