import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../NavigationManagementScreen/navigation_management_screen.dart';

class OnboardingBody extends StatelessWidget {
  final String assetName;
  final String buttonText;
  final Widget pageWidget;
  final Function()? onPressed;
  final bool onboardingLoginScreen;
  const OnboardingBody({
    Key? key,
    required this.assetName,
    this.buttonText = 'Próximo',
    required this.pageWidget,
    required this.onPressed,
    required this.onboardingLoginScreen,
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onboardingLoginScreen)
                  ElevatedButton(
                    child: const Text('Entrar como anônimo'),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.white,
                      onPrimary: AppColors.profilePrimary,
                      side: const BorderSide(
                        color: AppColors.profilePrimary,
                      ),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => const NavigationManagementScreen()),
                    ),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: Text(buttonText),
                  style: ElevatedButton.styleFrom(primary: AppColors.profilePrimary),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
