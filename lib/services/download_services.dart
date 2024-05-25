import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class FileDownloaderServices {
  void downloadFile(String fileUrl, String fileName, BuildContext context) {
    FileDownloader.downloadFile(
        url: fileUrl,
        name: fileName,
        downloadDestination: DownloadDestinations.publicDownloads,
        onProgress: (String? fileName, double? progress) {
          print('FILE $fileName HAS PROGRESS $progress');
          _showSnackbarMessage(context, 'FILE $fileName started to download');
        },

        onDownloadCompleted: (String path) {
          print('FILE DOWNLOADED TO PATH: $path');
          _showSnackbarMessage(context, 'FILE DOWNLOADED TO PATH: $path');
        },
        onDownloadError: (String error) {
          print('DOWNLOAD ERROR: $error');
          _showSnackbarMessage(context, 'DOWNLOAD ERROR: $error');
        }
    );
  }

  void _showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
