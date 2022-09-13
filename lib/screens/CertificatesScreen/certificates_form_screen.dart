import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/certificate_screen_mode.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:intl/intl.dart';
import '../../common/models/certificate.dart';
import 'components/certificate_form_field.dart';
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
  DateTime date = DateTime.now();

  @override
  void initState() {
    if (widget.certificate != null) {
      courseTextController.text = widget.certificate!.course;
      institutionTextController.text = widget.certificate!.institution;
      descriptionTextController.text = widget.certificate!.description;
      imageUrlTextController.text = widget.certificate!.imageUrl ?? '';
      credentialUrlTextController.text = widget.certificate!.credentialUrl;
      date = DateTime.parse(widget.certificate!.date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.certificatesPrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CertificateFormField(
                label: text.certificateFormCourseLabel,
                controller: courseTextController,
                maxLength: 20,
              ),
              CertificateFormField(
                label: text.certificateFormInstitutionLabel,
                controller: institutionTextController,
                maxLength: 20,
              ),
              CertificateFormField(
                label: text.certificateFormDescriptionLabel,
                controller: descriptionTextController,
                maxLength: 140,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CertificateFormField(
                          label: text.certificateFormImageUrlLabel,
                          controller: imageUrlTextController,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        CertificateFormField(
                          label: text.certificateFormCredentialUrlLabel,
                          controller: credentialUrlTextController,
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (newDate == null) return;
                    setState(() => date = newDate);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.certificatesPrimary,
                      ),
                      const SizedBox(width: 16),
                      Text(DateFormat("dd/MM/yyyy").format(date)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isAddScreenMode)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.removeCertificate!(widget.certificate!.id!);
                      },
                      style: TextButton.styleFrom(foregroundColor: AppColors.snackBarError),
                      child: Text(text.certificateFormRemoveButton),
                    ),
                  const Spacer(),
                  if (!isAddScreenMode)
                    ElevatedButton(
                      onPressed: () {
                        validateNewCertificate();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.certificatesPrimary),
                      child: Text(text.certificateFormUpdateButton),
                    ),
                  if (isAddScreenMode)
                    ElevatedButton(
                      onPressed: () {
                        validateNewCertificate();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.certificatesPrimary),
                      child: Text(text.certificateFormSendButton),
                    ),
                ],
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
        date: date.toIso8601String(),
      );
      isAddScreenMode ? widget.addCertificate!(_certificate) : widget.updateCertificate!(_certificate);
      Navigator.pop(context);
    }
  }

  bool get isAddScreenMode => widget.screenMode == CertificateScreenMode.ADD.value;
}
