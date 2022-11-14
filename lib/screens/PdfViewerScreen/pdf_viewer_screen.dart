import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: const Icon(Icons.share),
              onTap: () {
                Share.shareXFiles([XFile(widget.file.path)]);
              },
            ),
          ),
        ],
      ),
      body: PdfView(
        path: widget.file.path,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
