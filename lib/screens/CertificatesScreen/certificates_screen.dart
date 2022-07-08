import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/certificates_data.dart';
import 'components/certificate_expandable_card.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyCertificatesData = CertificatesData;
    return Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: kIsWeb ? 0 : 64),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: dummyCertificatesData.length,
          itemBuilder: (ctx, i) => CertificateExpandableCard(certificate: dummyCertificatesData[i]),
        ),
      ),
    );
  }
}
