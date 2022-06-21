import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/data/icons_data.dart';

import '../../../core/core.dart';

class DepositionCard extends StatelessWidget {
  final Deposition deposition;
  final bool isRightSide;
  const DepositionCard({
    Key? key,
    required this.deposition,
    required this.isRightSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _iconsData = IconsData;
    return Row(
      mainAxisAlignment: isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                height: 120,
                width: 256,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 16, left: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: isRightSide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        deposition.name,
                        style: AppTextStyles.textNormal12.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.depositionsPrimary,
                        ),
                      ),
                      Text(
                        deposition.relationship,
                        style: AppTextStyles.textNormal12.copyWith(
                          color: AppColors.depositionsPrimary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deposition.deposition,
                        style: AppTextStyles.textNormal12.copyWith(
                          color: AppColors.black,
                        ),
                        textAlign: isRightSide ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: isRightSide ? 20 : null,
              left: isRightSide ? null : 20,
              child: Image.asset(
                _iconsData[deposition.iconIndex],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
