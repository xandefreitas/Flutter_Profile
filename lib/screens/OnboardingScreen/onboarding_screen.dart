import 'package:flutter/material.dart';
import 'package:flutter_profile/core/core.dart';

import '../NavigationManagementScreen/navigation_management_screen.dart';
import 'components/custom_snackbar.dart';
import 'components/onboarding_body.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController(initialPage: 0);

  final _formKey = GlobalKey<FormState>();

  bool snackBarIsClosed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          OnboardingBody(
            assetName: 'assets/images/onboarding_01.png',
            pageWidget: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: 280,
                  child: Text(
                    'Bem vindo(a) ao meu aplicativo, aqui você vai encontrar um pouco da minha experiência trabalhando com flutter!',
                    style: AppTextStyles.textSize24.copyWith(
                      color: AppColors.profilePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            nextButtonIsVisible: snackBarIsClosed,
            onPressed: () {
              _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
          OnboardingBody(
            assetName: 'assets/images/onboarding_02.png',
            pageWidget: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 80.0,
                  left: 32,
                  right: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Antes de continuarmos, informe seu Nome e E-mail',
                        style: AppTextStyles.textSize24.copyWith(
                          color: AppColors.profilePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          hintStyle: const TextStyle(color: AppColors.profilePrimary),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (name) {
                          return name!.trim().isEmpty ? 'Campo Obrigatório' : null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          return email!.trim().isEmpty ? 'Campo Obrigatório' : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            nextButtonIsVisible: snackBarIsClosed,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
          ),
          OnboardingBody(
            assetName: 'assets/images/onboarding_03.png',
            pageWidget: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Text(
                  'Tudo pronto!\nAgora vamos ao aplicativo!',
                  style: AppTextStyles.textSize24.copyWith(
                    color: AppColors.profilePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            nextButtonIsVisible: snackBarIsClosed,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavigationManagementScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showCustomSnackBar(BuildContext context, String title, String subtitle, IconData icon, Color? snackBarColor) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: CustomSnackBar(
              title: title,
              subtitle: subtitle,
              icon: icon,
              snackBarColor: snackBarColor,
            ),
            duration: const Duration(seconds: 10),
          ),
        )
        .closed
        .then((value) => setState(
              () => snackBarIsClosed = !snackBarIsClosed,
            ));
  }
}
