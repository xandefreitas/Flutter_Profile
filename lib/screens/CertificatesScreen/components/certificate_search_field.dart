import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/widgets/page_input_theme.dart';
import '../../../core/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Search field for filtering certificates by course name or description.
///
/// Debounces user input: [onSearchChanged] only fires once typing has
/// paused for [debounceDuration], so filtering doesn't run on every keystroke.
class CertificateSearchField extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final Duration debounceDuration;
  const CertificateSearchField({
    required this.onSearchChanged,
    this.debounceDuration = const Duration(seconds: 1),
    super.key,
  });

  @override
  State<CertificateSearchField> createState() => _CertificateSearchFieldState();
}

class _CertificateSearchFieldState extends State<CertificateSearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onSearchChanged(value);
    });
    setState(() {});
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onSearchChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return PageInputTheme(
      color: AppColors.certificatesPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(color: AppColors.certificatesPrimary),
          decoration: InputDecoration(
            hintText: text.certificatesSearchHint,
            hintStyle: TextStyle(
              color: AppColors.certificatesPrimary.withValues(alpha: 0.5),
            ),
            isDense: true,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.certificatesPrimary,
            ),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.certificatesPrimary,
                    ),
                    onPressed: _clear,
                  ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.certificatesPrimary,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
