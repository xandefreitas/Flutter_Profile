import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/core.dart';
import '../../../data/icons_data.dart';

class DepositionShimmerCard extends StatelessWidget {
  final bool isRightSide;
  const DepositionShimmerCard({
    Key? key,
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
                constraints: const BoxConstraints(maxWidth: 256),
                padding: EdgeInsets.only(top: 8.0, right: isRightSide ? 16 : 8, left: isRightSide ? 8 : 16, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.depositionsPrimary.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: isRightSide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.lightGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.lightGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.lightGrey,
                        ),
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
              child: Shimmer.fromColors(
                baseColor: AppColors.lightGrey,
                highlightColor: AppColors.depositionsPrimary.withOpacity(0.4),
                child: Image.asset(
                  _iconsData[0],
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
