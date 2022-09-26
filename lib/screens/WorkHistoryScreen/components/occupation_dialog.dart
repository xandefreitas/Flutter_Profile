import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_form_field.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import '../../../common/models/occupation.dart';
import '../../../common/widgets/custom_date_picker.dart';
import '../../../common/widgets/custom_dialog.dart';

class OccupationDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final TextEditingController roleTextController = TextEditingController();
        final TextEditingController descriptionTextController = TextEditingController();
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        String _startDate = occupation?.startDate ?? DateTime.now().toIso8601String();
        String _endDate = occupation?.endDate ?? DateTime.now().toIso8601String();
        Occupation _occupation = occupation ??
            Occupation(
              role: '',
              startDate: DateTime.now().toIso8601String(),
              endDate: DateTime.now().toIso8601String(),
              description: '',
            );
        if (isUpdateDialogMode) {
          roleTextController.text = occupation!.role;
          descriptionTextController.text = occupation!.description;
        }
        return CustomDialog(
          dialogColor: primaryColor,
          dialogTitle: isUpdateDialogMode ? 'Update Occupation' : 'New Occupation',
          dialogBody: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start Date:',
                      style: AppTextStyles.textSize16.copyWith(color: primaryColor),
                    ),
                    CustomDatePicker(
                      color: primaryColor,
                      initialDate: isUpdateDialogMode ? DateTime.tryParse(_startDate) : null,
                      setDate: (date) {
                        _startDate = date.toIso8601String();
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'End Date:',
                      style: AppTextStyles.textSize16.copyWith(color: primaryColor),
                    ),
                    CustomDatePicker(
                      color: primaryColor,
                      initialDate: isUpdateDialogMode ? DateTime.tryParse(_endDate) : null,
                      setDate: (date) {
                        _endDate = date.toIso8601String();
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 2),
                CustomFormField(
                  label: 'Role',
                  controller: roleTextController,
                  color: primaryColor,
                  maxLength: 25,
                  onSaved: (role) {
                    _occupation.role = role!;
                  },
                  validator: (role) => role == null || role.trim().isEmpty ? 'Required' : null,
                ),
                CustomFormField(
                  label: 'Description',
                  controller: descriptionTextController,
                  color: primaryColor,
                  maxLines: 3,
                  onSaved: (description) {
                    _occupation.description = description!;
                  },
                  validator: (description) => description == null || description.trim().isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
          dialogAction: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _occupation
                  ..startDate = _startDate
                  ..endDate = _endDate;
                _formKey.currentState!.save();
                manageOccupation(_occupation);
                Navigator.pop(context);
              }
            },
            child: Text(isUpdateDialogMode ? 'Update' : 'Add'),
          ),
        );
      },
    );
  }

  bool get isUpdateDialogMode => occupation != null;
}
