import 'package:flutter/material.dart';

import '../../../common/util/relationship_util.dart';
import '../../../core/core.dart';
import '../../../data/relationships_data.dart';
import '../../../l10n/app_localizations.dart';

class DepositionRelationshipDropdown extends StatefulWidget {
  final int relationshipValue;
  final Function(int) onChanged;
  final FocusNode? focusNode;
  const DepositionRelationshipDropdown({
    required this.relationshipValue,
    required this.onChanged,
    this.focusNode,
    super.key,
  });

  @override
  State<DepositionRelationshipDropdown> createState() =>
      _DepositionRelationshipDropdownState();
}

class _DepositionRelationshipDropdownState
    extends State<DepositionRelationshipDropdown> {
  final List<int> _relationshipItems = RelationshipsData;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return DropdownButtonFormField(
      isDense: true,
      isExpanded: true,
      elevation: 0,
      borderRadius: BorderRadius.circular(10),
      focusNode: widget.focusNode,
      initialValue: widget.relationshipValue,
      style: AppTextStyles.textSize12.copyWith(color: AppColors.black),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        label: Text(text.depositionButtonRelationshipHint),
        isDense: true,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        labelStyle: AppTextStyles.textSize12.copyWith(
          color: AppColors.black.withValues(alpha: 0.5),
        ),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      items: _relationshipItems
          .map(
            (e) => DropdownMenuItem<int>(
              value: e,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  RelationshipUtil.getRelationshipName(
                    context: context,
                    relationshipCode: e,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        widget.onChanged(value as int);
      },
    );
  }
}
