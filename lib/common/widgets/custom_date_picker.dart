import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';

// ignore: must_be_immutable
class CustomDatePicker extends StatefulWidget {
  final Color color;
  final Function(DateTime) setDate;
  final DateTime? initialDate;
  const CustomDatePicker({required this.color, required this.setDate, this.initialDate, super.key});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime currentDate;
  @override
  void initState() {
    currentDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (newDate == null) return;
        setState(() {
          currentDate = newDate;
          widget.setDate(newDate);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            color: widget.color,
          ),
          const SizedBox(width: 16),
          Text(
            DateFormat("dd/MM/yyyy").format(currentDate),
            style: AppTextStyles.textSize16.copyWith(color: widget.color),
          ),
        ],
      ),
    );
  }
}
