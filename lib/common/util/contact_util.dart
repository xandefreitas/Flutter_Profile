import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class ContactUtil {
  static launchUrl(String url, BuildContext context) async {
    final text = AppLocalizations.of(context)!;
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorOnUrlFailed(context, text.couldNotOpenUrlMessage);
      }
    } catch (e) {
      _showErrorOnUrlFailed(context, text.errorOpenningUrlMessage);
    }
  }

  static void _showErrorOnUrlFailed(BuildContext _context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }
}
