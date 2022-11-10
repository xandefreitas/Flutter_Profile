import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/work_history_screen_mode.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import '../../common/util/date_util.dart';
import '../../common/widgets/custom_dialog.dart';
import '../../common/widgets/custom_form_field.dart';
import '../../core/core.dart';
import 'components/occupation_dialog.dart';

class WorkHistoryFormScreen extends StatefulWidget {
  final Company? company;
  final String title;
  final int screenMode;
  final Function(Company)? addCompany;
  final Function(Company)? updateCompany;
  final Function(String)? removeCompany;
  const WorkHistoryFormScreen({
    Key? key,
    this.company,
    required this.title,
    required this.screenMode,
    this.addCompany,
    this.updateCompany,
    this.removeCompany,
  }) : super(key: key);

  @override
  State<WorkHistoryFormScreen> createState() => _WorkHistoryFormScreenState();
}

class _WorkHistoryFormScreenState extends State<WorkHistoryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color primaryColor = AppColors.workHistoryPrimary;
  final TextEditingController companyNameTextController = TextEditingController();
  late AppLocalizations text;
  List<Occupation> occupations = [];
  String languageCode = 'pt';

  @override
  void initState() {
    if (widget.company != null) {
      occupations.addAll(widget.company!.occupations);
      companyNameTextController.text = widget.company!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getLocale();
    text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          if (!isAddScreenMode)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      dialogTitle: text.deleteWorkHistoryDialogTitle,
                      dialogBody: Text(
                        text.deleteWorkHistoryDialogcontent,
                        textAlign: TextAlign.center,
                      ),
                      dialogColor: AppColors.workHistoryPrimary,
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
                              widget.removeCompany!(widget.company!.id!);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.workHistoryPrimary,
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
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomFormField(
                  label: text.workHistoryFormFieldCompanyLabel,
                  controller: companyNameTextController,
                  maxLength: 25,
                  color: primaryColor,
                  validator: (company) => company == null || company.isEmpty ? text.formValidatorMessage : null,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text.workHistoryFieldOccupationsLabel,
                            style: AppTextStyles.textSize16.copyWith(color: primaryColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return OccupationDialog(
                                      primaryColor: primaryColor,
                                      manageOccupation: addOccupation,
                                    );
                                  }),
                                );
                              },
                              child: Icon(
                                Icons.add_box_rounded,
                                color: primaryColor,
                                size: 32,
                              ),
                            ),
                          ),
                          ...occupations.reversed.map((e) {
                            final String formattedStartDate = DateUtil.formatDate(e.startDate);
                            final String formattedEndDate = DateUtil.formatDate(e.endDate);
                            return Column(
                              children: [
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(e.role, style: AppTextStyles.textMedium),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return OccupationDialog(
                                                    primaryColor: primaryColor,
                                                    occupation: e,
                                                    manageOccupation: (occupation) {
                                                      setState(() {
                                                        e = occupation;
                                                        modifyCompany();
                                                      });
                                                    },
                                                  );
                                                }),
                                              );
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: primaryColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                occupations.remove(e);
                                              });
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '$formattedStartDate - $formattedEndDate',
                                        style: AppTextStyles.textSize12,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(languageCode == 'pt' ? e.description : e.descriptionEn),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    modifyCompany();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(isAddScreenMode ? text.workHistoryFormSendButton : text.workHistoryFormUpdateButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  modifyCompany() {
    if (_formKey.currentState!.validate()) {
      final company = Company(id: widget.company?.id, name: companyNameTextController.text, occupations: occupations);
      isAddScreenMode ? widget.addCompany!(company) : widget.updateCompany!(company);
      Navigator.pop(context);
    }
  }

  addOccupation(Occupation? occupation) {
    if (occupation != null) {
      setState(() {
        occupations.add(occupation);
      });
    }
  }

  void _getLocale() {
    final locale = Localizations.localeOf(context);
    languageCode = locale.languageCode;
    super.didChangeDependencies();
  }

  bool get isAddScreenMode => widget.screenMode == WorkHistoryScreenMode.ADD.value;
}
