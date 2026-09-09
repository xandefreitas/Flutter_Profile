import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Central place for every custom analytics event logged by this app, so
/// event names/parameter keys are defined once instead of scattered as raw
/// strings across every screen that fires one.
abstract class AnalyticsUtil {
  /// Analytics is a side effect, never a requirement for the interaction it
  /// tracks — swallow any failure (e.g. no Firebase app in a test/host
  /// environment) instead of letting it propagate into the caller's tap
  /// handler or bloc event.
  static Future<void> _log(String name, {Map<String, Object>? parameters}) async {
    try {
      await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> logAppInit() => _log('app_init');

  static Future<void> logLanguageChangedOnStart(String languageCode) =>
      _log('language_changed_on_start', parameters: {'language': languageCode});

  static Future<void> logOnboardingWelcomeNextTapped() => _log('onboarding_welcome_next_tapped');

  static Future<void> logLoginPhoneNumber() => _log('login_phone_number');

  static Future<void> logLoginAnonymous() => _log('login_anonymous');

  static Future<void> logOnboardingCompleted() => _log('onboarding_completed');

  static Future<void> logProfileScreenVisit() => _log('profile_screen_visit');

  static Future<void> logSkillUpvoted(String skillTitle) =>
      _log('skill_upvoted', parameters: {'skill': skillTitle});

  static Future<void> logLanguageBarTooltipOpened(String languageTitle) =>
      _log('language_bar_tooltip_opened', parameters: {'language': languageTitle});

  static Future<void> logDrawerOpened() => _log('drawer_opened');

  static Future<void> logLinkedinIconOpened() => _log('linkedin_icon_opened');

  static Future<void> logGithubIconOpened() => _log('github_icon_opened');

  static Future<void> logWhatsappIconOpened() => _log('whatsapp_icon_opened');

  static Future<void> logCallMeBrazilOpened() => _log('call_me_brazil_opened');

  static Future<void> logCallMeSwedenOpened() => _log('call_me_sweden_opened');

  static Future<void> logSendMeEmailOpened() => _log('send_me_email_opened');

  static Future<void> logCvOpened(String fileName) =>
      _log('cv_opened', parameters: {'file_name': fileName});

  static Future<void> logCvShared(String fileName) =>
      _log('cv_shared', parameters: {'file_name': fileName});

  static Future<void> logLanguageChangedOnDrawer(String languageCode) =>
      _log('language_changed_on_drawer', parameters: {'language': languageCode});

  static Future<void> logAboutScreenVisit() => _log('about_screen_visit');

  static Future<void> logPrivacyPolicyScreenVisit() => _log('privacy_policy_screen_visit');

  static Future<void> logTermsOfServiceScreenVisit() => _log('terms_of_service_screen_visit');

  static Future<void> logDeleteAccountConfirmation() => _log('delete_account_confirmation');

  static Future<void> logLogout() => _log('logout');

  static Future<void> logCertificatesScreenVisit() => _log('certificates_screen_visit');

  static Future<void> logCertificatesSearchPerformed(String query) =>
      _log('certificates_search_performed', parameters: {'query': query});

  static Future<void> logCertificateExpanded(String courseName) =>
      _log('certificate_expanded', parameters: {'course': courseName});

  static Future<void> logCertificateCredentialOpened(String courseName) =>
      _log('certificate_credential_opened', parameters: {'course': courseName});

  static Future<void> logWorkHistoryScreenVisit() => _log('work_history_screen_visit');

  static Future<void> logWorkHistoryDescriptionOpened(String role) =>
      _log('work_history_description_opened', parameters: {'role': role});

  static Future<void> logWorkHistoryCompanyUrlOpened(String companyName) =>
      _log('work_history_company_url_opened', parameters: {'company': companyName});

  static Future<void> logDepositionsScreenVisit() => _log('depositions_screen_visit');

  static Future<void> logDepositionAdded() => _log('deposition_added');

  static Future<void> logDepositionEdited() => _log('deposition_edited');

  static Future<void> logDepositionDeleted() => _log('deposition_deleted');
}
