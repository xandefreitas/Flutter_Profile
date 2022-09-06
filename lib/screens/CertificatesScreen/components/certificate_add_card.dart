import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/certificate_screen_mode.dart';

import '../../../common/models/certificate.dart';
import '../../../common/util/app_routes.dart';
import '../../../core/core.dart';

class CertificateAddCard extends StatelessWidget {
  final Function(Certificate) addCertificate;
  const CertificateAddCard({required this.addCertificate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          certificatesFormRoute,
          arguments: {
            "title": 'Add Certificate',
            "addCertificate": addCertificate,
            "screenMode": CertificateScreenMode.ADD.value,
          },
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.certificatesPrimary.withOpacity(0.4),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
