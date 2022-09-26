import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/certificate_screen_mode.dart';
import 'package:flutter_profile/common/widgets/custom_date_picker.dart';
import 'package:flutter_profile/core/app_colors.dart';
import '../../common/models/certificate.dart';
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
  final TextEditingController institutionTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  final TextEditingController imageUrlTextController = TextEditingController();
  final TextEditingController credentialUrlTextController = TextEditingController();
  final Color primaryColor = AppColors.certificatesPrimary;
  DateTime certificateDate = DateTime.now();

  @override
  void initState() {
    if (widget.certificate != null) {
      courseTextController.text = widget.certificate!.course;
      institutionTextController.text = widget.certificate!.institution;
      descriptionTextController.text = widget.certificate!.description;
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
          if (!isAddScreenMode)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  widget.removeCertificate!(widget.certificate!.id!);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.delete),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomDatePicker(
                        color: primaryColor,
                        setDate: (date) {
                          certificateDate = date;
                        },
                      ),
                    ),
                    CustomFormField(
                      label: text.certificateFormCourseLabel,
                      controller: courseTextController,
                      maxLength: 20,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formFieldRequiredMessage : null,
                    ),
                    CustomFormField(
                      label: text.certificateFormInstitutionLabel,
                      controller: institutionTextController,
                      maxLength: 20,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formFieldRequiredMessage : null,
                    ),
                    CustomFormField(
                      label: text.certificateFormDescriptionLabel,
                      controller: descriptionTextController,
                      maxLength: 200,
                      maxLines: 5,
                      color: primaryColor,
                      validator: (value) => value == null || value.isEmpty ? text.formFieldRequiredMessage : null,
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
      final Certificate _certificate = Certificate(
        id: widget.certificate?.id,
        course: courseTextController.text,
        institution: institutionTextController.text,
        description: descriptionTextController.text,
        imageUrl: imageUrlTextController.text,
        credentialUrl: credentialUrlTextController.text,
        date: certificateDate.toIso8601String(),
      );
      isAddScreenMode ? widget.addCertificate!(_certificate) : widget.updateCertificate!(_certificate);
      Navigator.pop(context);
    }
  }

  bool get isAddScreenMode => widget.screenMode == CertificateScreenMode.ADD.value;
}
