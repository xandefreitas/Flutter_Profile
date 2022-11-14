import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_form_field.dart';
import 'package:flutter_profile/core/core.dart';
import '../../../common/models/occupation.dart';
import '../../../common/widgets/custom_date_picker.dart';
import '../../../common/widgets/custom_dialog.dart';

class OccupationDialog extends StatefulWidget {
  final Color primaryColor;
  final Function(Occupation) manageOccupation;
  final Occupation? occupation;
  const OccupationDialog({
    required this.primaryColor,
    required this.manageOccupation,
    this.occupation,
    super.key,
  });

  @override
  State<OccupationDialog> createState() => _OccupationDialogState();
}

class _OccupationDialogState extends State<OccupationDialog> {
  final TextEditingController roleTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  final TextEditingController descriptionEnTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Occupation _occupation;
  late bool isCurrentOccupation;
  late AppLocalizations text;
  String _startDate = '';
  String _endDate = '';

  @override
  void initState() {
    _startDate = widget.occupation?.startDate ?? DateTime.now().toIso8601String();
    _endDate =
        (widget.occupation?.endDate == null || widget.occupation!.endDate.isEmpty) ? DateTime.now().toIso8601String() : widget.occupation!.endDate;
    isCurrentOccupation = widget.occupation?.isCurrentOccupation ?? false;
    _occupation = widget.occupation ??
        Occupation(
          role: '',
          startDate: DateTime.now().toIso8601String(),
          endDate: DateTime.now().toIso8601String(),
          description: '',
          descriptionEn: '',
          isCurrentOccupation: false,
        );
    if (isUpdateDialogMode) {
      roleTextController.text = widget.occupation!.role;
      descriptionTextController.text = widget.occupation!.description;
      descriptionEnTextController.text = widget.occupation!.descriptionEn;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return StatefulBuilder(
      builder: (context, setState) {
        return CustomDialog(
          dialogColor: widget.primaryColor,
          dialogTitle: isUpdateDialogMode ? text.occupationsFormTitleUpdate : text.occupationsFormTitleAdd,
          dialogBody: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text.occupationsFormStartDateLabel,
                      style: AppTextStyles.textSize16.copyWith(color: widget.primaryColor),
                    ),
                    CustomDatePicker(
                      color: widget.primaryColor,
                      initialDate: isUpdateDialogMode ? DateTime.tryParse(_startDate) : null,
                      setDate: (date) {
                        _startDate = date.toIso8601String();
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: !isCurrentOccupation,
                  child: Column(
                    children: [
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            text.occupationsFormEndDateLabel,
                            style: AppTextStyles.textSize16.copyWith(color: widget.primaryColor),
                          ),
                          CustomDatePicker(
                            color: widget.primaryColor,
                            initialDate: isUpdateDialogMode ? DateTime.tryParse(_endDate) : null,
                            setDate: (date) {
                              _endDate = date.toIso8601String();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text.occupationsFormCurrentOccupationLabel,
                      style: AppTextStyles.textSize16.copyWith(color: widget.primaryColor),
                    ),
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const ContinuousRectangleBorder(),
                      value: isCurrentOccupation,
                      onChanged: ((value) {
                        setState(
                          () {
                            isCurrentOccupation = value!;
                          },
                        );
                      }),
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                CustomFormField(
                  label: text.occupationsFormRoleLabel,
                  controller: roleTextController,
                  color: widget.primaryColor,
                  maxLength: 35,
                  onSaved: (role) {
                    _occupation.role = role!;
                  },
                  validator: (role) => role == null || role.trim().isEmpty ? text.formValidatorMessage : null,
                ),
                CustomFormField(
                  label: text.occupationsFormDescriptionLabel,
                  controller: descriptionTextController,
                  color: widget.primaryColor,
                  maxLines: 2,
                  onSaved: (description) {
                    _occupation.description = description!;
                  },
                  validator: (description) => description == null || description.trim().isEmpty ? text.formValidatorMessage : null,
                ),
                CustomFormField(
                  label: text.occupationsFormDescriptionEnLabel,
                  controller: descriptionEnTextController,
                  color: widget.primaryColor,
                  maxLines: 2,
                  onSaved: (descriptionEn) {
                    _occupation.descriptionEn = descriptionEn!;
                  },
                  validator: (descriptionEn) => descriptionEn == null || descriptionEn.trim().isEmpty ? text.formValidatorMessage : null,
                ),
              ],
            ),
          ),
          dialogAction: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _occupation
                  ..startDate = _startDate
                  ..endDate = isCurrentOccupation ? '' : _endDate
                  ..isCurrentOccupation = isCurrentOccupation;
                _formKey.currentState!.save();
                widget.manageOccupation(_occupation);
                Navigator.pop(context);
              }
            },
            child: Text(isUpdateDialogMode ? text.workHistoryFormUpdateButton : text.workHistoryFormAddButton),
          ),
        );
      },
    );
  }

  bool get isUpdateDialogMode => widget.occupation != null;
}
