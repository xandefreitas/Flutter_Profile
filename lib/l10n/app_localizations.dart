import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('pt'),
    Locale('sv'),
  ];

  /// Welcome message for new users
  ///
  /// In en, this message translates to:
  /// **'Welcome to my app, here you will find a little of my experiences and abilities with Flutter!'**
  String get onboardingWelcomeMessage;

  /// login message for new users
  ///
  /// In en, this message translates to:
  /// **'Before we continue, verify your Phone Number'**
  String get onboardingLoginMessage;

  /// enter name message for new users
  ///
  /// In en, this message translates to:
  /// **'Almost done! Now please inform your Name'**
  String get onboardingEnterNameMessage;

  /// onboarding complete message
  ///
  /// In en, this message translates to:
  /// **'All set!\nLet\'s Continue to the app!'**
  String get onboardingCompleteMessage;

  /// onboarding Proceed button text
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get onboardingProceedButtonText;

  /// onboarding next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNextButtonText;

  /// onboarding next button text
  ///
  /// In en, this message translates to:
  /// **'Login as anonymous'**
  String get loginAsAnonymousButtonText;

  /// custom drawer title contact me
  ///
  /// In en, this message translates to:
  /// **'Contact Me'**
  String get drawerTitleContactMe;

  /// custom drawer call swedish number button
  ///
  /// In en, this message translates to:
  /// **'Call me: Sweden!'**
  String get drawerCallSwedenButton;

  /// custom drawer call brazilian number button
  ///
  /// In en, this message translates to:
  /// **'Call me: Brazil!'**
  String get drawerCallBrazilButton;

  /// custom drawer send mail button
  ///
  /// In en, this message translates to:
  /// **'Send me an E-Mail!'**
  String get drawerEmailButton;

  /// custom drawer title download my curriculum
  ///
  /// In en, this message translates to:
  /// **'Download my CV'**
  String get drawerTitleDownloadMyCV;

  /// custom drawer title Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerTitleLanguage;

  /// Portuguese label
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portugueseLabel;

  /// English label
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @spanishLabel.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLabel;

  /// Swedish label
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedishLabel;

  /// tooltip description of proficiency in Portuguese
  ///
  /// In en, this message translates to:
  /// **'My native language. Born and raised in Salvador, a city in the northeast of Brazil, in the state of Bahia.'**
  String get portugueseLanguageDescription;

  /// tooltip description of proficiency in English
  ///
  /// In en, this message translates to:
  /// **'Pretty much fluent at this point — exchange programs and living abroad really helped me get comfortable with the language.'**
  String get englishLanguageDescription;

  /// tooltip description of proficiency in Spanish
  ///
  /// In en, this message translates to:
  /// **'Being from a Latin American country and with a few exchange programs along the way, I\'ve talked with plenty of Spanish speakers — enough to hold a decent conversation.'**
  String get spanishLanguageDescription;

  /// tooltip description of proficiency in Swedish
  ///
  /// In en, this message translates to:
  /// **'Living in Sweden for 3 years, listening to podcasts, and recently joined SFI so I can comprehend and speak the language properly.'**
  String get swedishLanguageDescription;

  /// exit button label at the end of drawer
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get drawerLogoutButton;

  /// custom form hint for textfield name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get formHintTextName;

  /// form validator message required field
  ///
  /// In en, this message translates to:
  /// **'Required Field'**
  String get formValidatorMessage;

  /// form button for editing phone number
  ///
  /// In en, this message translates to:
  /// **'Edit Number'**
  String get formEditNumberButtonText;

  /// form button for resending OTP code
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get formResendButtonText;

  /// hint text for phone number input
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get formPhoneNumberLabelText;

  /// field min length message on form validate
  ///
  /// In en, this message translates to:
  /// **'Name must have more than 4 letters'**
  String get formFieldMinLengthMessage;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Certificates screen title
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificatesTitle;

  /// Certificates screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Check out my certificates!'**
  String get certificatesSubtitle;

  /// work history screen title
  ///
  /// In en, this message translates to:
  /// **'Work History'**
  String get workHistoryTitle;

  /// work history screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Know my previous experiences!'**
  String get workHistorySubtitle;

  /// Deposition screen title
  ///
  /// In en, this message translates to:
  /// **'Depositions'**
  String get depositionsTitle;

  /// Deposition screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Write something about me or my app!'**
  String get depositionsSubtitle;

  /// Deposition screen secondary subtitle
  ///
  /// In en, this message translates to:
  /// **'Login to leave your deposition!'**
  String get depositionsSecondarySubtitle;

  /// login message on profile modal
  ///
  /// In en, this message translates to:
  /// **'Verify your Phone Number to access more app functionalities'**
  String get profileLoginMessage;

  /// role text on profile screen
  ///
  /// In en, this message translates to:
  /// **'Computer Engineer'**
  String get profileRole;

  /// No description provided for @alertSnackBarLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login First!'**
  String get alertSnackBarLoginTitle;

  /// alert snackbar message text when user not logged in
  ///
  /// In en, this message translates to:
  /// **'You have to login to access this functionality'**
  String get alertSnackBarLoginMessage;

  /// error snackbar title text on invalid OTP code insert
  ///
  /// In en, this message translates to:
  /// **'Code is Invalid!'**
  String get errorSnackBarInvalidCodeTitle;

  /// error snackbar message text on invalid OTP code insert
  ///
  /// In en, this message translates to:
  /// **'Try again or tap Resend to get a new code.'**
  String get errorSnackBarInvalidCodeMessage;

  /// Menu button on profile screen
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get profileMenuButton;

  /// Login button on profile screen
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get profileLoginButton;

  /// About Me label on profile screen
  ///
  /// In en, this message translates to:
  /// **'About Me:'**
  String get aboutMeProfileLabel;

  /// Skills label on profile screen
  ///
  /// In en, this message translates to:
  /// **'Skills:'**
  String get skillsProfileLabel;

  /// Delete skill dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Skill'**
  String get skillsDeleteDialogTitle;

  /// Delete skill dialog content message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this skill from the list?'**
  String get skillsDeleteDialogContent;

  /// Delete skill dialog cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get skillsDeleteDialogCancelButton;

  /// Delete skill dialog confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get skillsDeleteDialogConfirmButton;

  /// Add skill dialog title
  ///
  /// In en, this message translates to:
  /// **'New Skill'**
  String get skillsAddDialogTitle;

  /// Add skill dialog add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get skillsAddDialogAddButton;

  /// Language label on profile screen
  ///
  /// In en, this message translates to:
  /// **'Languages:'**
  String get languagesProfileLabel;

  /// about me description
  ///
  /// In en, this message translates to:
  /// **'Highly passionate, innovative and technically-astute mobile developer, well-versed in analyzing user needs and developing software to precisely meet diverse needs. Very keen to learn new programming languages and proactively keeps up with industry trends. Great knowledge in Flutter/Dart, BLoC pattern, Agile methodologies (Scrum/Kanban), Firebase, UI/UX, Figma, clean code, code version control with Git/Git Flow and Play Store and App Store app distributions.'**
  String get aboutMeDescription;

  /// Course label on certificate expandable card
  ///
  /// In en, this message translates to:
  /// **'Course:'**
  String get certificateCardCourseLabel;

  /// Institution label on certificate expandable card
  ///
  /// In en, this message translates to:
  /// **'Institution:'**
  String get certificateCardInstitutionLabel;

  /// Credential link label on certificate expandable card
  ///
  /// In en, this message translates to:
  /// **'Credential'**
  String get certificateCardCredentialLinkLabel;

  /// success snackbar title text when deposition was sent successfully
  ///
  /// In en, this message translates to:
  /// **'Deposition Sent!'**
  String get successSnackBarDepositionTitle;

  /// success snackbar message when deposition was sent successfully
  ///
  /// In en, this message translates to:
  /// **'Thank you for leaving your deposition!'**
  String get successSnackBarDepositionAddedMessage;

  /// success snackbar message when deposition was updated successfully
  ///
  /// In en, this message translates to:
  /// **'Your deposition was updated!'**
  String get successSnackBarDepositionUpdatedMessage;

  /// success snackbar message when deposition was removed successfully
  ///
  /// In en, this message translates to:
  /// **'Deposition removed successfully.'**
  String get successSnackBarDepositionRemovedMessage;

  /// Full name textfield hint on deposition button
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get depositionButtonNameHint;

  /// Relationship dropdown hint on deposition button
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get depositionButtonRelationshipHint;

  /// Deposition textfield hint on deposition button
  ///
  /// In en, this message translates to:
  /// **'Write something about me or my app!'**
  String get depositionButtonDepositionHint;

  /// Send button on deposition button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get depositionButtonSendButton;

  /// Existing deposition dialog title
  ///
  /// In en, this message translates to:
  /// **'Existing Deposition'**
  String get existingDepositionDialogTitle;

  /// Existing deposition dialog content text
  ///
  /// In en, this message translates to:
  /// **'You have writen a deposition already, if you wish to write a new one, the previous one will be updated!'**
  String get existingDepositionDialogContent;

  /// Existing deposition dialog update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get existingDepositionDialogUpdateButton;

  /// Existing deposition dialog cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get existingDepositionDialogCancelButton;

  /// Anonymous text when user name is null on new deposition
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymousNameDeposition;

  /// Delete deposition dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Deposition'**
  String get deleteDepositionDialogTitle;

  /// Delete deposition dialog content text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this deposition?'**
  String get deleteDepositionDialogcontent;

  /// Delete deposition dialog cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deleteDialogCancelButton;

  /// Delete deposition dialog confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get deleteDialogConfirmButton;

  /// Deposition screen message when there are no depositions yet
  ///
  /// In en, this message translates to:
  /// **'There are still no depositions around here!'**
  String get depositionScreenEmptyMessage;

  /// Deposition screen secondary message when there are no depositions yet
  ///
  /// In en, this message translates to:
  /// **'Why don\'t you write something?'**
  String get depositionScreenEmptySecondaryMessage;

  /// Deposition screen secondary message for anonymous when there are no depositions yet
  ///
  /// In en, this message translates to:
  /// **'Please login if you want to write something.'**
  String get depositionScreenEmptyAnonymousMessage;

  /// E-mail and Whatsapp custom message
  ///
  /// In en, this message translates to:
  /// **'Hello, Alexandre!'**
  String get urlMessage;

  /// message for when the url could not be launched
  ///
  /// In en, this message translates to:
  /// **'Could not launch Url!'**
  String get couldNotOpenUrlMessage;

  /// message for when there is an error openning an url
  ///
  /// In en, this message translates to:
  /// **'Error on launching Url!'**
  String get errorOpenningUrlMessage;

  /// Send button text on new certificate form
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get certificateFormSendButton;

  /// Update button text on new certificate form
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get certificateFormUpdateButton;

  /// Remove button text on new certificate form
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get certificateFormRemoveButton;

  /// Delete certificate dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Certificate'**
  String get deleteCertificateDialogTitle;

  /// Delete certificate dialog content text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this certificate?'**
  String get deleteCertificateDialogcontent;

  /// Course label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get certificateFormCourseLabel;

  /// Duration label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get certificateFormDurationLabel;

  /// Institution label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get certificateFormInstitutionLabel;

  /// Description label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get certificateFormDescriptionLabel;

  /// English Description label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'English Description'**
  String get certificateFormDescriptionEnLabel;

  /// Image Url label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Image Url'**
  String get certificateFormImageUrlLabel;

  /// Credential Url label on certificate form field
  ///
  /// In en, this message translates to:
  /// **'Credential Url'**
  String get certificateFormCredentialUrlLabel;

  /// Certificate form screen Add title text
  ///
  /// In en, this message translates to:
  /// **'Add Certificate'**
  String get certificateFormScreenTitleAdd;

  /// Certificate form screen Update title text
  ///
  /// In en, this message translates to:
  /// **'Update Certificate'**
  String get certificateFormScreenTitleUpdate;

  /// Certificate form screen Update title text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorStateDialogTitle;

  /// Certificate form screen Update title text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorStateDialogRetryButton;

  /// Relationship data list item friend
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get relationshipDataFriend;

  /// Relationship data list item Coworker
  ///
  /// In en, this message translates to:
  /// **'Coworker'**
  String get relationshipDataCoworker;

  /// Relationship data list item Boss
  ///
  /// In en, this message translates to:
  /// **'Boss'**
  String get relationshipDataBoss;

  /// Relationship data list item Client
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get relationshipDataClient;

  /// Relationship data list item Family
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get relationshipDataFamily;

  /// Relationship data list item Recruiter
  ///
  /// In en, this message translates to:
  /// **'Recruiter'**
  String get relationshipDataRecruiter;

  /// SnackBar generic error title
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get snackBarGenericErrorTitle;

  /// SnackBar generic success title
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get snackBarGenericSuccessTitle;

  /// SnackBar generic alert title
  ///
  /// In en, this message translates to:
  /// **'Alert!'**
  String get snackBarGenericAlertTitle;

  /// success snackbar message text when certificate added successfully
  ///
  /// In en, this message translates to:
  /// **'A new certificate was added!'**
  String get successSnackBarAddedCertificate;

  /// success snackbar message text when certificate updated successfully
  ///
  /// In en, this message translates to:
  /// **'Certificate updated successfully.'**
  String get successSnackBarUpdatedCertificate;

  /// success snackbar message text when certificate removed successfully
  ///
  /// In en, this message translates to:
  /// **'Certificate removed successfully.'**
  String get successSnackBarRemovedCertificate;

  /// form title when adding a new work history
  ///
  /// In en, this message translates to:
  /// **'Add Work History'**
  String get workHistoryFormTitleAdd;

  /// form title when updating a work history
  ///
  /// In en, this message translates to:
  /// **'Update Work History'**
  String get workHistoryFormTitleUpdate;

  /// work history company form field label
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get workHistoryFormFieldCompanyLabel;

  /// work history occupations field label
  ///
  /// In en, this message translates to:
  /// **'Occupations'**
  String get workHistoryFieldOccupationsLabel;

  /// Send button text on new work history form
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get workHistoryFormSendButton;

  /// Update button text on new work history form
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get workHistoryFormUpdateButton;

  /// Add button text on new work history form
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get workHistoryFormAddButton;

  /// Delete work history dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Work History'**
  String get deleteWorkHistoryDialogTitle;

  /// Delete work history dialog content text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this work history?'**
  String get deleteWorkHistoryDialogcontent;

  /// success snackbar message text when work history added successfully
  ///
  /// In en, this message translates to:
  /// **'A new work history was added!'**
  String get successSnackBarAddedWorkHistory;

  /// success snackbar message text when work history updated successfully
  ///
  /// In en, this message translates to:
  /// **'Work History updated successfully.'**
  String get successSnackBarUpdatedWorkHistory;

  /// success snackbar message text when work history removed successfully
  ///
  /// In en, this message translates to:
  /// **'Work History removed successfully.'**
  String get successSnackBarRemovedWorkHistory;

  /// form title when adding a new work history
  ///
  /// In en, this message translates to:
  /// **'Add Occupation'**
  String get occupationsFormTitleAdd;

  /// form title when updating a work history
  ///
  /// In en, this message translates to:
  /// **'Update Occupation'**
  String get occupationsFormTitleUpdate;

  /// occupations start date label
  ///
  /// In en, this message translates to:
  /// **'Start Date:'**
  String get occupationsFormStartDateLabel;

  /// occupations end date label
  ///
  /// In en, this message translates to:
  /// **'End Date:'**
  String get occupationsFormEndDateLabel;

  /// occupations current occupation checkbox label
  ///
  /// In en, this message translates to:
  /// **'Current Occupation'**
  String get occupationsFormCurrentOccupationLabel;

  /// occupations formfield Role label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get occupationsFormRoleLabel;

  /// occupations formfield Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get occupationsFormDescriptionLabel;

  /// occupations formfield English Description label
  ///
  /// In en, this message translates to:
  /// **'English Description'**
  String get occupationsFormDescriptionEnLabel;

  /// about button label at the end of drawer
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawerAboutButton;

  /// about screen info message about user data
  ///
  /// In en, this message translates to:
  /// **'Hello there, the data you see bellow is the only info we have about your user.'**
  String get aboutInfoMessage;

  /// delete account dialog display name label with value
  ///
  /// In en, this message translates to:
  /// **'Display Name: {name}'**
  String deleteAccountDisplayNameLabel(String name);

  /// delete account dialog phone number label with value
  ///
  /// In en, this message translates to:
  /// **'Phone Number: {phoneNumber}'**
  String deleteAccountPhoneNumberLabel(String phoneNumber);

  /// delete account button text
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// delete account confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountDialogTitle;

  /// delete account confirmation dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountDialogContent;

  /// delete account otp verification dialog title
  ///
  /// In en, this message translates to:
  /// **'Verify It\'s You'**
  String get deleteAccountOtpDialogTitle;

  /// delete account otp verification dialog content
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your phone number. Enter it below to confirm the account deletion.'**
  String get deleteAccountOtpDialogContent;
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
      <String>['en', 'pt', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
