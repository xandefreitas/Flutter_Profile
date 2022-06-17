import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class NewDepositionButton extends StatefulWidget {
  final Function() onNewDeposition;
  final bool isWritingDeposition;
  const NewDepositionButton({
    Key? key,
    required this.onNewDeposition,
    required this.isWritingDeposition,
  }) : super(key: key);

  @override
  State<NewDepositionButton> createState() => _NewDepositionButtonState();
}

class _NewDepositionButtonState extends State<NewDepositionButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: AppColors.depositionsPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            height: widget.isWritingDeposition ? 280 : 40,
            width: widget.isWritingDeposition ? 272 : 40,
            child: widget.isWritingDeposition
                ? const Form(
                    child: SizedBox(),
                  )
                : InkWell(
                    onTap: () {
                      widget.onNewDeposition();
                    },
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
