import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/core.dart';

class CertificateShimmerCard extends StatelessWidget {
  const CertificateShimmerCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        highlightColor: AppColors.certificatesPrimary.withOpacity(1),
        baseColor: AppColors.certificatesPrimary.withOpacity(0.2),
        child: Container(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          height: 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.certificatesPrimary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
