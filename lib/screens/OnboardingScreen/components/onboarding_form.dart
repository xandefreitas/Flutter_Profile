import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';

import '../../../common/api/auth_webclient.dart';
import '../../../common/util/snackbar_util.dart';
import '../../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../../core/core.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final int verificationStatusIndex;
  final Function() nextVerificationStatusIndex;
  final Function() firstVerificationStatusIndex;

  const OnboardingForm({
    required GlobalKey<FormState> formKey,
    required this.verificationStatusIndex,
    required this.nextVerificationStatusIndex,
    required this.firstVerificationStatusIndex,
    super.key,
  }) : _formKey = formKey;

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  TextEditingController otpCodeController = TextEditingController();
  String shortPhoneNumber = '';
  String completePhoneNumber = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  int timeoutDuration = 60;
  bool isNotVerifying = true;
  late AppLocalizations text;
  late Timer resendCodeTimer;
  late AuthWebclient authWebclient;

  @override
  void initState() {
    authWebclient = AuthWebclient(auth: auth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          formFieldSetter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.verificationStatusIndex == 1,
                replacement: const Spacer(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  child: InkWell(
                    onTap: () {
                      resendCodeTimer.cancel();
                      otpCodeController.clear();
                      timeoutDuration = 60;
                      widget._formKey.currentState!.reset();
                      widget.firstVerificationStatusIndex();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text.formEditNumberButtonText,
                        style: AppTextStyles.textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppColors.profilePrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(visible: widget.verificationStatusIndex == 1 && timeoutDuration != 0, child: Text(timeoutDuration.toString())),
              Visibility(
                visible: widget.verificationStatusIndex == 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  child: InkWell(
                    onTap: () async => onResend(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text.formResendButtonText,
                        style: AppTextStyles.textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: timeoutDuration == 0 ? AppColors.profilePrimary : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget formFieldSetter() {
    return switch (widget.verificationStatusIndex) { 1 => otpCodeTextField(), 2 => nameTextField(), _ => phoneTextField() };
  }

  IntlPhoneField phoneTextField() {
    return IntlPhoneField(
      initialCountryCode: 'BR',
      textInputAction: TextInputAction.done,
      disableLengthCheck: true,
      decoration: InputDecoration(
        suffixIcon: Visibility(
          visible: isNotVerifying,
          replacement: Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(
              color: AppColors.profilePrimary,
            ),
          ),
          child: GestureDetector(
            child: const Icon(Icons.send),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (shortPhoneNumber.isNotEmpty) {
                onVerify();
              } else {
                showError('Invalid Number', 'Please insert a valid number to continue or login as anonymous.');
              }
            },
          ),
        ),
        labelText: text.formPhoneNumberLabelText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (phone) {
        if (widget._formKey.currentState!.validate()) {
          shortPhoneNumber = phone.number;
          completePhoneNumber = phone.completeNumber;
        }
      },
      onSubmitted: (phone) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (shortPhoneNumber.isNotEmpty) {
          onVerify();
        } else {
          showError('Invalid Number', 'Please insert a valid number to continue or login as anonymous.');
        }
      },
    );
  }

  TextFormField nameTextField() {
    return TextFormField(
      initialValue: auth.currentUser?.displayName ?? '',
      decoration: InputDecoration(
        label: Text(text.formHintTextName),
        hintText: text.formHintTextName,
        hintStyle: const TextStyle(color: AppColors.profilePrimary),
        isDense: true,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.name,
      validator: (name) {
        if (name!.trim().isEmpty) {
          return text.formValidatorMessage;
        } else if (name.length <= 3) {
          return text.formFieldMinLengthMessage;
        } else {
          authWebclient.updateDisplayName(name);
          return null;
        }
      },
    );
  }

  Pinput otpCodeTextField() {
    return Pinput(
      length: 6,
      controller: otpCodeController,
      onCompleted: (pin) {
        try {
          authWebclient.signIn(pin: pin).whenComplete(() {
            widget.nextVerificationStatusIndex();
            otpCodeController.clear();
            resendCodeTimer.cancel();
          });
        } catch (e) {
          otpCodeController.clear();
          SnackBarUtil.showCustomSnackBar(
            context: context,
            snackbar: ErrorSnackBar(
              title: text.errorSnackBarInvalidCodeTitle,
              subtitle: text.errorSnackBarInvalidCodeMessage,
            ),
          );
        }
      },
    );
  }

  void startResendCodeTimer() {
    timeoutDuration = 60;
    resendCodeTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timeoutDuration <= 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          timeoutDuration--;
        });
      }
    });
  }

  Future<void> onVerify() async {
    setState(
      () {
        isNotVerifying = false;
      },
    );
    if (widget._formKey.currentState!.validate()) {
      await authWebclient.verifyNumber(
        phoneNumber: completePhoneNumber,
        timeoutDuration: timeoutDuration,
        whenVerified: () {
          setState(
            () {
              isNotVerifying = true;
            },
          );
          startResendCodeTimer();
          completePhoneNumber = '';
          shortPhoneNumber = '';
          widget.nextVerificationStatusIndex();
        },
        onError: showError,
      );
    }
  }

  void showError(String errorTitle, String message) {
    SnackBarUtil.showCustomSnackBar(
      context: context,
      snackbar: ErrorSnackBar(
        title: errorTitle,
        subtitle: message,
      ),
    );
    setState(
      () {
        isNotVerifying = true;
      },
    );
  }

  void onResend() {
    if (timeoutDuration == 0) {
      startResendCodeTimer();
      otpCodeController.clear();
      authWebclient.verifyNumber(
        phoneNumber: completePhoneNumber,
        timeoutDuration: timeoutDuration,
        whenVerified: () {
          startResendCodeTimer();
        },
        onError: showError,
      );
    }
  }
}
