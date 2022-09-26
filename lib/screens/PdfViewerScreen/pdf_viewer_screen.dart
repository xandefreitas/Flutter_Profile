import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfViewerScreen extends StatefulWidget {
  final File file;
  final String title;
  const PdfViewerScreen({super.key, required this.file, required this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: AppColors.profilePrimary,
      ),
      body: PdfView(
        path: widget.file.path,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
