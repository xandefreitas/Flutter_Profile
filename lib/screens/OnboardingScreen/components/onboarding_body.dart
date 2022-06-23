import 'package:flutter/material.dart';

import '../../../core/core.dart';

class OnboardingBody extends StatelessWidget {
  final String assetName;
  final Widget pageWidget;
  final Function()? onPressed;
  final bool nextButtonIsVisible;
  const OnboardingBody({
    Key? key,
    required this.assetName,
    required this.pageWidget,
    required this.onPressed,
    required this.nextButtonIsVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            assetName,
            fit: BoxFit.contain,
          ),
        ),
        pageWidget,
        nextButtonIsVisible
            ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Próximo'),
                    style: ElevatedButton.styleFrom(primary: AppColors.profilePrimary),
                    onPressed: onPressed,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
