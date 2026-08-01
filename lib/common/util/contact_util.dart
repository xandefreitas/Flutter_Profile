import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../l10n/app_localizations.dart';

class ContactUtil {
  final BuildContext context;
  final AppLocalizations text;

  ContactUtil({required this.context, required this.text});

  void launchUrl(String url) {
    try {
      canLaunchUrlString(url).then((canLaunch) {
        if (canLaunch) {
          launchUrlString(url, mode: LaunchMode.externalApplication);
        }
      });
    } catch (e) {
      _showErrorOnUrlFailed(context, text.errorOpenningUrlMessage);
    }
  }

  void launchWhatsApp(String url) {
    final phoneNumber = url.replaceAll(' ', '');
    final whatsAppUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(text.urlMessage)}';
    launchUrl(whatsAppUrl);
  }

  void launchMail(String mail) {
    final mailUrl = 'mailto:$mail?subject=${Uri.encodeFull('ProfileApp')}&body=${Uri.encodeFull(text.urlMessage)}';
    launchUrl(mailUrl);
  }

  void launchPhone(String cellphone) {
    final phoneNumber = cellphone.replaceAll(' ', '');
    final phoneUrl = 'tel:$phoneNumber';
    launchUrl(phoneUrl);
  }

  static void _showErrorOnUrlFailed(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
