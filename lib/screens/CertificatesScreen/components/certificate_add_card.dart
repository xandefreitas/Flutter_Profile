import 'package:flutter/material.dart';
import '../../../common/enums/certificate_screen_mode.dart';
import '../../../common/models/certificate.dart';
import '../../../common/util/app_routes.dart';
import '../../../common/widgets/custom_add_card.dart';
import '../../../core/core.dart';
import '../../../l10n/app_localizations.dart';

class CertificateAddCard extends StatelessWidget {
  final Function(Certificate) addCertificate;
  const CertificateAddCard({required this.addCertificate, super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return CustomAddCard(
      color: AppColors.certificatesPrimary.withValues(alpha: 0.4),
      onTap: () => Navigator.pushNamed(
        context,
        certificatesFormRoute,
        arguments: {
          'title': text.certificateFormScreenTitleAdd,
          'addCertificate': addCertificate,
          'screenMode': CertificateScreenMode.ADD.value,
        },
      ),
    );
  }
}
