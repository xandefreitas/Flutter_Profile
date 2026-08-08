// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingWelcomeMessage =>
      'Welcome to my app, here you will find a little of my experiences and abilities with Flutter!';

  @override
  String get onboardingLoginMessage =>
      'Before we continue, verify your Phone Number';

  @override
  String get onboardingEnterNameMessage =>
      'Almost done! Now please inform your Name';

  @override
  String get onboardingCompleteMessage =>
      'All set!\nLet\'s Continue to the app!';

  @override
  String get onboardingProceedButtonText => 'Proceed';

  @override
  String get onboardingNextButtonText => 'Next';

  @override
  String get loginAsAnonymousButtonText => 'Login as anonymous';

  @override
  String get drawerTitleContactMe => 'Contact Me';

  @override
  String get drawerCallSwedenButton => 'Call me: Sweden!';

  @override
  String get drawerCallBrazilButton => 'Call me: Brazil!';

  @override
  String get drawerEmailButton => 'Send me an E-Mail!';

  @override
  String get drawerTitleDownloadMyCV => 'Download my CV';

  @override
  String get drawerTitleLanguage => 'Language';

  @override
  String get portugueseLabel => 'Portuguese';

  @override
  String get englishLabel => 'English';

  @override
  String get spanishLabel => 'Spanish';

  @override
  String get swedishLabel => 'Swedish';

  @override
  String get portugueseLanguageDescription =>
      'My native language. Born and raised in Salvador, a city in the northeast of Brazil, in the state of Bahia.';

  @override
  String get englishLanguageDescription =>
      'Pretty much fluent at this point — exchange programs and living abroad really helped me get comfortable with the language.';

  @override
  String get spanishLanguageDescription =>
      'Being from a Latin American country and with a few exchange programs along the way, I\'ve talked with plenty of Spanish speakers — enough to hold a decent conversation.';

  @override
  String get swedishLanguageDescription =>
      'Living in Sweden for 3 years, listening to podcasts, and recently joined SFI so I can comprehend and speak the language properly.';

  @override
  String get drawerLogoutButton => 'Exit';

  @override
  String get formHintTextName => 'Name';

  @override
  String get formValidatorMessage => 'Required Field';

  @override
  String get formEditNumberButtonText => 'Edit Number';

  @override
  String get formResendButtonText => 'Resend';

  @override
  String get formPhoneNumberLabelText => 'Phone Number';

  @override
  String get formFieldMinLengthMessage => 'Name must have more than 4 letters';

  @override
  String get profileTitle => 'Profile';

  @override
  String get certificatesTitle => 'Certificates';

  @override
  String get certificatesSubtitle => 'Check out my certificates!';

  @override
  String get workHistoryTitle => 'Work History';

  @override
  String get workHistorySubtitle => 'Know my previous experiences!';

  @override
  String get depositionsTitle => 'Depositions';

  @override
  String get depositionsSubtitle => 'Write something about me or my app!';

  @override
  String get depositionsSecondarySubtitle => 'Login to leave your deposition!';

  @override
  String get profileLoginMessage =>
      'Verify your Phone Number to access more app functionalities';

  @override
  String get profileRole => 'Computer Engineer';

  @override
  String get alertSnackBarLoginTitle => 'Login First!';

  @override
  String get alertSnackBarLoginMessage =>
      'You have to login to access this functionality';

  @override
  String get errorSnackBarInvalidCodeTitle => 'Code is Invalid!';

  @override
  String get errorSnackBarInvalidCodeMessage =>
      'Try again or tap Resend to get a new code.';

  @override
  String get profileMenuButton => 'Menu';

  @override
  String get profileLoginButton => 'Login';

  @override
  String get aboutMeProfileLabel => 'About Me:';

  @override
  String get skillsProfileLabel => 'Skills:';

  @override
  String get skillsDeleteDialogTitle => 'Delete Skill';

  @override
  String get skillsDeleteDialogContent =>
      'Are you sure you want to delete this skill from the list?';

  @override
  String get skillsDeleteDialogCancelButton => 'Cancel';

  @override
  String get skillsDeleteDialogConfirmButton => 'Confirm';

  @override
  String get skillsAddDialogTitle => 'New Skill';

  @override
  String get skillsAddDialogAddButton => 'Add';

  @override
  String get languagesProfileLabel => 'Languages:';

  @override
  String get aboutMeDescription =>
      'Highly passionate, innovative and technically-astute mobile developer, well-versed in analyzing user needs and developing software to precisely meet diverse needs. Very keen to learn new programming languages and proactively keeps up with industry trends. Great knowledge in Flutter/Dart, BLoC pattern, Agile methodologies (Scrum/Kanban), Firebase, UI/UX, Figma, clean code, code version control with Git/Git Flow and Play Store and App Store app distributions.';

  @override
  String get certificateCardCourseLabel => 'Course:';

  @override
  String get certificateCardInstitutionLabel => 'Institution:';

  @override
  String get certificateCardCredentialLinkLabel => 'Credential';

  @override
  String get successSnackBarDepositionTitle => 'Deposition Sent!';

  @override
  String get successSnackBarDepositionAddedMessage =>
      'Thank you for leaving your deposition!';

  @override
  String get successSnackBarDepositionUpdatedMessage =>
      'Your deposition was updated!';

  @override
  String get successSnackBarDepositionRemovedMessage =>
      'Deposition removed successfully.';

  @override
  String get depositionButtonNameHint => 'Full Name';

  @override
  String get depositionButtonRelationshipHint => 'Relationship';

  @override
  String get depositionButtonDepositionHint =>
      'Write something about me or my app!';

  @override
  String get depositionButtonSendButton => 'Send';

  @override
  String get existingDepositionDialogTitle => 'Existing Deposition';

  @override
  String get existingDepositionDialogContent =>
      'You have writen a deposition already, if you wish to write a new one, the previous one will be updated!';

  @override
  String get existingDepositionDialogUpdateButton => 'Update';

  @override
  String get existingDepositionDialogCancelButton => 'Cancel';

  @override
  String get anonymousNameDeposition => 'Anonymous';

  @override
  String get deleteDepositionDialogTitle => 'Delete Deposition';

  @override
  String get deleteDepositionDialogcontent =>
      'Are you sure you want to delete this deposition?';

  @override
  String get deleteDialogCancelButton => 'Cancel';

  @override
  String get deleteDialogConfirmButton => 'Confirm';

  @override
  String get depositionScreenEmptyMessage =>
      'There are still no depositions around here!';

  @override
  String get depositionScreenEmptySecondaryMessage =>
      'Why don\'t you write something?';

  @override
  String get depositionScreenEmptyAnonymousMessage =>
      'Please login if you want to write something.';

  @override
  String get urlMessage => 'Hello, Alexandre!';

  @override
  String get couldNotOpenUrlMessage => 'Could not launch Url!';

  @override
  String get errorOpenningUrlMessage => 'Error on launching Url!';

  @override
  String get certificateFormSendButton => 'Send';

  @override
  String get certificateFormUpdateButton => 'Update';

  @override
  String get certificateFormRemoveButton => 'Remove';

  @override
  String get deleteCertificateDialogTitle => 'Delete Certificate';

  @override
  String get deleteCertificateDialogcontent =>
      'Are you sure you want to delete this certificate?';

  @override
  String get certificateFormCourseLabel => 'Course';

  @override
  String get certificateFormDurationLabel => 'Duration';

  @override
  String get certificateFormInstitutionLabel => 'Institution';

  @override
  String get certificateFormDescriptionLabel => 'Description';

  @override
  String get certificateFormDescriptionEnLabel => 'English Description';

  @override
  String get certificateFormImageUrlLabel => 'Image Url';

  @override
  String get certificateFormCredentialUrlLabel => 'Credential Url';

  @override
  String get certificateFormScreenTitleAdd => 'Add Certificate';

  @override
  String get certificateFormScreenTitleUpdate => 'Update Certificate';

  @override
  String get errorStateDialogTitle => 'Error';

  @override
  String get errorStateDialogRetryButton => 'Retry';

  @override
  String get relationshipDataFriend => 'Friend';

  @override
  String get relationshipDataCoworker => 'Coworker';

  @override
  String get relationshipDataBoss => 'Boss';

  @override
  String get relationshipDataClient => 'Client';

  @override
  String get relationshipDataFamily => 'Family';

  @override
  String get relationshipDataRecruiter => 'Recruiter';

  @override
  String get snackBarGenericErrorTitle => 'Something went wrong!';

  @override
  String get snackBarGenericSuccessTitle => 'Success!';

  @override
  String get snackBarGenericAlertTitle => 'Alert!';

  @override
  String get successSnackBarAddedCertificate => 'A new certificate was added!';

  @override
  String get successSnackBarUpdatedCertificate =>
      'Certificate updated successfully.';

  @override
  String get successSnackBarRemovedCertificate =>
      'Certificate removed successfully.';

  @override
  String get workHistoryFormTitleAdd => 'Add Work History';

  @override
  String get workHistoryFormTitleUpdate => 'Update Work History';

  @override
  String get workHistoryFormFieldCompanyLabel => 'Company';

  @override
  String get workHistoryFieldOccupationsLabel => 'Occupations';

  @override
  String get workHistoryFormSendButton => 'Send';

  @override
  String get workHistoryFormUpdateButton => 'Update';

  @override
  String get workHistoryFormAddButton => 'Add';

  @override
  String get deleteWorkHistoryDialogTitle => 'Delete Work History';

  @override
  String get deleteWorkHistoryDialogcontent =>
      'Are you sure you want to delete this work history?';

  @override
  String get successSnackBarAddedWorkHistory => 'A new work history was added!';

  @override
  String get successSnackBarUpdatedWorkHistory =>
      'Work History updated successfully.';

  @override
  String get successSnackBarRemovedWorkHistory =>
      'Work History removed successfully.';

  @override
  String get occupationsFormTitleAdd => 'Add Occupation';

  @override
  String get occupationsFormTitleUpdate => 'Update Occupation';

  @override
  String get occupationsFormStartDateLabel => 'Start Date:';

  @override
  String get occupationsFormEndDateLabel => 'End Date:';

  @override
  String get occupationsFormCurrentOccupationLabel => 'Current Occupation';

  @override
  String get occupationsFormRoleLabel => 'Role';

  @override
  String get occupationsFormDescriptionLabel => 'Description';

  @override
  String get occupationsFormDescriptionEnLabel => 'English Description';

  @override
  String get drawerSettingsButton => 'Settings';

  @override
  String get settingsInfoMessage =>
      'Hello there, the data you see bellow is the only info we have about your user.';

  @override
  String settingsDisplayNameLabel(String name) {
    return 'Display Name: $name';
  }

  @override
  String settingsPhoneNumberLabel(String phoneNumber) {
    return 'Phone Number: $phoneNumber';
  }

  @override
  String get settingsDeleteAccountButton => 'Delete Account';
}
