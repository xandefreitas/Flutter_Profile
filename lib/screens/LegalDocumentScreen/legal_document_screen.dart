import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../core/app_colors.dart';

class LegalDocumentScreen extends StatefulWidget {
  final String documentName;
  final String title;

  const LegalDocumentScreen({
    required this.documentName,
    required this.title,
    super.key,
  });

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  late final Future<String> _documentFuture = rootBundle.loadString(
    'assets/legal/${widget.documentName}_${Localizations.localeOf(context).languageCode}.txt',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.profilePrimary,
        foregroundColor: AppColors.white,
      ),
      body: FutureBuilder<String>(
        future: _documentFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.profilePrimary),
            );
          }
          return Markdown(
            data: snapshot.data!,
            padding: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }
}
