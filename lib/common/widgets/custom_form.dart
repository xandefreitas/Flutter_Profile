import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import '../../core/core.dart';
import 'custom_snackbar.dart';

class CustomForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final int verificationStatusIndex;
  final Function() nextVerificationStatusIndex;
  final Function() firstVerificationStatusIndex;

  const CustomForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.verificationStatusIndex,
    required this.nextVerificationStatusIndex,
    required this.firstVerificationStatusIndex,
  })  : _formKey = formKey,
        super(key: key);

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  late AppLocalizations text;
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String verificationId = '';
  String phoneNumber = '';
  FirebaseAuth auth = FirebaseAuth.instance;

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
              widget.verificationStatusIndex == 1
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          otpCodeController.clear();
                          widget._formKey.currentState!.reset();
                          widget.firstVerificationStatusIndex();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Edit Number',
                            style: AppTextStyles.textMedium.copyWith(
                              decoration: TextDecoration.underline,
                              color: AppColors.profilePrimary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Spacer(),
              if (widget.verificationStatusIndex == 1)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  child: InkWell(
                    onTap: () {
                      otpCodeController.clear();
                      verifyNumber();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Resend',
                        style: AppTextStyles.textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppColors.profilePrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.verificationStatusIndex == 0)
                InkWell(
                  onTap: () {
                    if (widget._formKey.currentState!.validate()) {
                      verifyNumber();
                      widget.nextVerificationStatusIndex();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Verify',
                      style: AppTextStyles.textMedium.copyWith(
                        decoration: TextDecoration.underline,
                        color: AppColors.profilePrimary,
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
    switch (widget.verificationStatusIndex) {
      case 1:
        return otpCodeTextField();
      case 2:
        return nameTextField();
      default:
        return phoneTextField();
    }
  }

  IntlPhoneField phoneTextField() {
    return IntlPhoneField(
      initialCountryCode: 'BR',
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (phone) {
        if (widget._formKey.currentState!.validate()) phoneNumber = phone.completeNumber;
      },
    );
  }

  TextFormField nameTextField() {
    return TextFormField(
      controller: nameController,
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
          return 'Field Required';
        } else if (nameController.text.length <= 4) {
          return 'Name must have more than 4 letters';
        } else {
          return null;
        }
      },
      onFieldSubmitted: (name) async {
        if (widget._formKey.currentState!.validate()) {
          await auth.currentUser!.updateDisplayName(name);
        }
      },
    );
  }

  Pinput otpCodeTextField() {
    return Pinput(
      length: 6,
      controller: otpCodeController,
      onCompleted: (pin) async {
        try {
          await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin)).then((value) {
            widget.nextVerificationStatusIndex();
            otpCodeController.clear();
          });
        } catch (e) {
          otpCodeController.clear();
          showCustomSnackBar(context, title: 'Code is Invalid!', subtitle: 'Try again or tap Resend to get a new code.');
        }
      },
    );
  }

  showCustomSnackBar(BuildContext context, {required String title, required String subtitle}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(title: title, subtitle: subtitle));
  }

  verifyNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseException e) {
        showCustomSnackBar(context, title: e.code, subtitle: e.message ?? '');
      },
      codeSent: (String verificationID, int? resendToken) async {
        setState(() {
          verificationId = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          verificationId = verificationID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }
}
