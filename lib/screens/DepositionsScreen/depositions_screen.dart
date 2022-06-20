import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_card.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/new_deposition_button.dart';

import '../../data/depositions_data.dart';

class DepositionsScreen extends StatefulWidget {
  final FocusNode textFocus;
  const DepositionsScreen({
    Key? key,
    required this.textFocus,
  }) : super(key: key);

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
            itemBuilder: (ctx, i) => DepositionCard(
              deposition: depositionsData[i],
              isRightSide: isRightSide(i),
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
            textFocus: widget.textFocus,
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
