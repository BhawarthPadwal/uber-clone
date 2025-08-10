import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RideSeva'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RideSeva'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started with RideSeva'**
  String get getStarted;

  /// No description provided for @continueTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTxt;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'What\'s your email'**
  String get enterEmail;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name'**
  String get enterName;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get enterConfirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get passwordHint;

  /// No description provided for @emailWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailWarning;

  /// No description provided for @invalidEmailWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmailWarning;

  /// No description provided for @passwordWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordWarning;

  /// No description provided for @confirmPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordWarning;

  /// No description provided for @passwordMatchWarning.
  ///
  /// In en, this message translates to:
  /// **'Password do not match'**
  String get passwordMatchWarning;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Kindly fill all fields'**
  String get warning;

  /// No description provided for @inviteTxt.
  ///
  /// In en, this message translates to:
  /// **'Join a fleet?'**
  String get inviteTxt;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// No description provided for @captainNameLabel.
  ///
  /// In en, this message translates to:
  /// **'What\'s our Captain\'s name'**
  String get captainNameLabel;

  /// No description provided for @captainEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'What\'s our Captain\'s email'**
  String get captainEmailLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @firstNameWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter your firstname'**
  String get firstNameWarning;

  /// No description provided for @lastNameWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter your lastname'**
  String get lastNameWarning;

  /// No description provided for @vehicleInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfoLabel;

  /// No description provided for @vehicleColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColorLabel;

  /// No description provided for @vehiclePlateLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate'**
  String get vehiclePlateLabel;

  /// No description provided for @vehicleCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Capacity'**
  String get vehicleCapacityLabel;

  /// No description provided for @selectVehicleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicleTypeLabel;

  /// No description provided for @carLabel.
  ///
  /// In en, this message translates to:
  /// **'car'**
  String get carLabel;

  /// No description provided for @motorcycleLabel.
  ///
  /// In en, this message translates to:
  /// **'motorcycle'**
  String get motorcycleLabel;

  /// No description provided for @autoLabel.
  ///
  /// In en, this message translates to:
  /// **'auto'**
  String get autoLabel;

  /// No description provided for @vehicleColorWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle color'**
  String get vehicleColorWarning;

  /// No description provided for @vehiclePlateWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle plate'**
  String get vehiclePlateWarning;

  /// No description provided for @vehicleCapacityWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter vehicle capacity'**
  String get vehicleCapacityWarning;

  /// No description provided for @vehicleTypeWarning.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type'**
  String get vehicleTypeWarning;

  /// No description provided for @signInAsUser.
  ///
  /// In en, this message translates to:
  /// **'Sign in as User'**
  String get signInAsUser;

  /// No description provided for @signInAsCaptain.
  ///
  /// In en, this message translates to:
  /// **'Sign in as Captain'**
  String get signInAsCaptain;

  /// No description provided for @registerAsCaptain.
  ///
  /// In en, this message translates to:
  /// **'Register as a Captain'**
  String get registerAsCaptain;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @newRideAvailable.
  ///
  /// In en, this message translates to:
  /// **'New Ride Available'**
  String get newRideAvailable;

  /// No description provided for @confirmRideToStart.
  ///
  /// In en, this message translates to:
  /// **'Confirm Ride to Start!'**
  String get confirmRideToStart;

  /// No description provided for @rideInProgress.
  ///
  /// In en, this message translates to:
  /// **'Ride in Progress'**
  String get rideInProgress;

  /// No description provided for @waitingForPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment'**
  String get waitingForPayment;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get rideCompleted;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @pleaseEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get pleaseEnterOTP;

  /// No description provided for @waitingForPaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment Confirmation'**
  String get waitingForPaymentConfirmation;

  /// No description provided for @findATrip.
  ///
  /// In en, this message translates to:
  /// **'Find a trip'**
  String get findATrip;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @searchVehicles.
  ///
  /// In en, this message translates to:
  /// **'Search Vehicles'**
  String get searchVehicles;

  /// No description provided for @youAreHere.
  ///
  /// In en, this message translates to:
  /// **'You are here'**
  String get youAreHere;

  /// No description provided for @chooseAVehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose a vehicle'**
  String get chooseAVehicle;

  /// No description provided for @affordableCompactRides.
  ///
  /// In en, this message translates to:
  /// **'Affordable, compact rides'**
  String get affordableCompactRides;

  /// No description provided for @bookA.
  ///
  /// In en, this message translates to:
  /// **'Book A'**
  String get bookA;

  /// No description provided for @noFareFetched.
  ///
  /// In en, this message translates to:
  /// **'No fare fetched'**
  String get noFareFetched;

  /// No description provided for @lookingForNearbyDrivers.
  ///
  /// In en, this message translates to:
  /// **'Looking for nearby drivers'**
  String get lookingForNearbyDrivers;

  /// No description provided for @cancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRide;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @completedRide.
  ///
  /// In en, this message translates to:
  /// **'Completed Ride'**
  String get completedRide;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// No description provided for @paymentDone.
  ///
  /// In en, this message translates to:
  /// **'Payment Done'**
  String get paymentDone;

  /// No description provided for @waitingForConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Confirmation'**
  String get waitingForConfirmation;

  /// No description provided for @rideStarted.
  ///
  /// In en, this message translates to:
  /// **'Ride Started'**
  String get rideStarted;

  /// No description provided for @makePayment.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get makePayment;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'kn', 'mr', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
    case 'mr': return AppLocalizationsMr();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
