import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

enum MediaKind { image, video, document, pdf, audio, voiceNote }

class MediaUploadTask {
  const MediaUploadTask({
    required this.path,
    required this.kind,
    required this.progress,
  });

  final String path;
  final MediaKind kind;
  final double progress;
}

class MediaService {
  MediaService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadMedia({
    required File file,
    required String remotePath,
    required MediaKind kind,
  }) async {
    final preparedFile = await _prepareFile(file, kind);
    final task = await _storage.ref(remotePath).putFile(preparedFile);
    return task.ref.getDownloadURL();
  }

  Future<File> _prepareFile(File file, MediaKind kind) async {
    // Hook for image compression and video compression before upload.
    return file;
  }
}
