import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

abstract class ResumeUtil {
  static Future downloadResume(Reference reference) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${reference.name}');

    await reference.writeToFile(file);
    return file;
  }

  static Future? openResume(String url) {
    try {
      final referenceResume = FirebaseStorage.instance.ref().child(url);

      return downloadResume(referenceResume);
    } catch (e) {
      return null;
    }
  }
}
