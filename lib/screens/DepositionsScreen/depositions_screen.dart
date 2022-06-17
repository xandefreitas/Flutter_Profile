import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/new_deposition_button.dart';

import '../../data/depositions_data.dart';

const _iconList = [
  'assets/images/man_01.png',
  'assets/images/man_02.png',
  'assets/images/man_03.png',
  'assets/images/man_04.png',
  'assets/images/man_05.png',
  'assets/images/man_06.png',
  'assets/images/woman_01.png',
  'assets/images/woman_02.png',
  'assets/images/woman_03.png',
  'assets/images/woman_04.png',
  'assets/images/woman_05.png',
  'assets/images/woman_06.png',
];

class DepositionsScreen extends StatefulWidget {
  const DepositionsScreen({Key? key}) : super(key: key);

  @override
  State<DepositionsScreen> createState() => _DepositionsScreenState();
}

class _DepositionsScreenState extends State<DepositionsScreen> {
  bool _isWritingDeposition = false;

  @override
  Widget build(BuildContext context) {
    final depositionsData = DepositionsData;
    return Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: 64),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: depositionsData.length,
            itemBuilder: (ctx, i) => Row(
              mainAxisAlignment: isRightSide(i) ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                          padding: const EdgeInsets.only(top: 8.0, right: 16, left: 16),
                          child: Column(
                            crossAxisAlignment: isRightSide(i) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                depositionsData[i].name,
                                style: AppTextStyles.textNormal12.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.depositionsPrimary,
                                ),
                              ),
                              Text(
                                depositionsData[i].relationship,
                                style: AppTextStyles.textNormal12.copyWith(
                                  color: AppColors.depositionsPrimary.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                depositionsData[i].deposition,
                                style: AppTextStyles.textNormal12.copyWith(
                                  color: AppColors.black,
                                ),
                                textAlign: isRightSide(i) ? TextAlign.right : TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: isRightSide(i) ? 20 : null,
                      left: isRightSide(i) ? null : 20,
                      child: Image.asset(
                        _iconList[depositionsData[i].iconIndex],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isWritingDeposition)
            GestureDetector(
              onTap: () => onNewDeposition(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.depositionsPrimary.withOpacity(0.4),
              ),
            ),
          NewDepositionButton(
            onNewDeposition: onNewDeposition,
            isWritingDeposition: _isWritingDeposition,
          ),
        ],
      ),
    );
  }

  onNewDeposition() {
    setState(() {
      _isWritingDeposition = !_isWritingDeposition;
    });
  }

  bool isRightSide(int i) => i % 2 == 0;
}
