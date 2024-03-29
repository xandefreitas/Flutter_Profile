import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/certificate_screen_mode.dart';
import 'package:flutter_profile/common/widgets/custom_date_picker.dart';
import 'package:flutter_profile/core/app_colors.dart';
import '../../common/models/certificate.dart';
import '../../common/widgets/custom_dialog.dart';
import '../../common/widgets/custom_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CertificatesFormScreen extends StatefulWidget {
  final Certificate? certificate;
  final String title;
  final int screenMode;
  final Function(Certificate)? addCertificate;
  final Function(Certificate)? updateCertificate;
  final Function(String)? removeCertificate;
  const CertificatesFormScreen({
    required this.title,
    required this.screenMode,
    required this.addCertificate,
    required this.updateCertificate,
    required this.removeCertificate,
    this.certificate,
    Key? key,
  }) : super(key: key);

  @override
  State<CertificatesFormScreen> createState() => _CertificatesFormScreenState();
}

class _CertificatesFormScreenState extends State<CertificatesFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController courseTextController = TextEditingController();
  final TextEditingController durationTextController = TextEditingController();
  final TextEditingController institutionTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  final TextEditingController descriptionEnTextController = TextEditingController();
  final TextEditingController imageUrlTextController = TextEditingController();
  final TextEditingController credentialUrlTextController = TextEditingController();
  final Color primaryColor = AppColors.certificatesPrimary;
  DateTime certificateDate = DateTime.now();

  @override
  void initState() {
    if (widget.certificate != null) {
      durationTextController.text = widget.certificate!.duration;
      courseTextController.text = widget.certificate!.course;
      institutionTextController.text = widget.certificate!.institution;
      descriptionTextController.text = widget.certificate!.description;
      descriptionEnTextController.text = widget.certificate!.descriptionEn;
      imageUrlTextController.text = widget.certificate!.imageUrl ?? '';
      credentialUrlTextController.text = widget.certificate!.credentialUrl;
      certificateDate = DateTime.parse(widget.certificate!.date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.certificatesPrimary,
        actions: [
          Visibility(
            visible: !isAddScreenMode,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      dialogTitle: text.deleteCertificateDialogTitle,
                      dialogBody: Text(
                        text.deleteCertificateDialogcontent,
                        textAlign: TextAlign.center,
                      ),
                      dialogColor: AppColors.certificatesPrimary,
                      dialogAction: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.snackBarError,
                            ),
                            child: Text(text.deleteDialogCancelButton),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.removeCertificate!(widget.certificate!.id!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.certificatesPrimary,
                            ),
                            child: Text(text.deleteDialogConfirmButton),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.delete),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomDatePicker(
                            initialDate: certificateDate,
                            color: primaryColor,
                            setDate: (date) {
                              certificateDate = date;
                            },
                          ),
                          const Spacer(),
                          Icon(
                            Icons.access_time_filled,
                            color: primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: CustomFormField(
                              keyBoardType: TextInputType.number,
                              label: text.certificateFormDurationLabel,
                              controller: durationTextController,
                              color: primaryColor,
                              suffixText: '/h',
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CustomFormField(
                                label: text.certificateFormImageUrlLabel,
                                controller: imageUrlTextController,
                                color: primaryColor,
                                onChanged: (value) {
                                  setState(() {});
                                  return null;
                                },
                              ),
                              CustomFormField(
                                label: text.certificateFormCredentialUrlLabel,
                                controller: credentialUrlTextController,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 120,
                          width: 120,
                          padding: const EdgeInsets.only(left: 8, top: 16),
                          child: Image.network(
                            imageUrlTextController.text,
                            errorBuilder: ((context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/certification_placeholder.png',
                                fit: BoxFit.cover,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    CustomFormField(
                      label: text.certificateFormCourseLabel,
                      controller: courseTextController,
                      maxLength: 25,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formValidatorMessage : null,
                    ),
                    CustomFormField(
                      label: text.certificateFormInstitutionLabel,
                      controller: institutionTextController,
                      maxLength: 20,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formValidatorMessage : null,
                    ),
                    CustomFormField(
                      label: text.certificateFormDescriptionLabel,
                      controller: descriptionTextController,
                      maxLength: 200,
                      maxLines: 4,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formValidatorMessage : null,
                    ),
                    CustomFormField(
                      label: text.certificateFormDescriptionEnLabel,
                      controller: descriptionEnTextController,
                      maxLength: 200,
                      maxLines: 4,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formValidatorMessage : null,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    validateNewCertificate();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(isAddScreenMode ? text.certificateFormSendButton : text.certificateFormUpdateButton),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  validateNewCertificate() {
    if (_formKey.currentState?.validate() ?? false) {
      final duration = double.tryParse(durationTextController.text)?.toStringAsFixed(1);
      final Certificate certificate = Certificate(
        id: widget.certificate?.id,
        course: courseTextController.text,
        duration: duration ?? '',
        institution: institutionTextController.text,
        description: descriptionTextController.text,
        descriptionEn: descriptionEnTextController.text,
        imageUrl: imageUrlTextController.text,
        credentialUrl: credentialUrlTextController.text,
        date: certificateDate.toIso8601String(),
      );
      isAddScreenMode ? widget.addCertificate!(certificate) : widget.updateCertificate!(certificate);
      Navigator.pop(context);
    }
  }

  bool get isAddScreenMode => widget.screenMode == CertificateScreenMode.ADD.value;
}
