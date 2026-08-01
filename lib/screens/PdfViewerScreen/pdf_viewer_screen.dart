import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_colors.dart';

class PdfViewerScreen extends StatefulWidget {
  final File file;
  final String title;
  const PdfViewerScreen({required this.file, required this.title, super.key});

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
        foregroundColor: AppColors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: const Icon(Icons.share),
              onTap: () {
                SharePlus.instance.share(
                  ShareParams(files: [XFile(widget.file.path)]),
                );
              },
            ),
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
        fitPolicy: FitPolicy.WIDTH,
        pageSnap: false,
        pageFling: false,
      ),
    );
  }
}
