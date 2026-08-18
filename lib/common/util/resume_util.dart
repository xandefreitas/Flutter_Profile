import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'shared_preferences_util.dart';

abstract class ResumeUtil {
  static final Map<String, Future<File>> _cachedDownloads = {};

  static Future<File> downloadResume(Reference reference) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${reference.name}');
    final fileExists = await file.exists();

    String? remoteHash;
    try {
      remoteHash = (await reference.getMetadata()).md5Hash;
    } catch (e) {
      if (fileExists) return file;
      rethrow;
    }

    final cachedHash = await SharedPreferencesUtil.getCachedResumeHash(
      reference.name,
    );
    if (fileExists && remoteHash != null && remoteHash == cachedHash) {
      return file;
    }

    await reference.writeToFile(file);
    if (remoteHash != null) {
      await SharedPreferencesUtil.setCachedResumeHash(
        reference.name,
        remoteHash,
      );
    }
    return file;
  }

  static Future<File>? openResume(String url) {
    final cached = _cachedDownloads[url];
    if (cached != null) {
      return cached;
    }

    try {
      final referenceResume = FirebaseStorage.instance.ref().child(url);
      final download = downloadResume(referenceResume);
      _cachedDownloads[url] = download;
      return download;
    } catch (e) {
      return null;
    }
  }
}
