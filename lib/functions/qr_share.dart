import 'dart:io';
import 'dart:ui';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

shareQrCode(ScreenshotController screenshotController, String name) async {
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  } else {
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.png').create();
          if (imagePath != null) {
            await imagePath.writeAsBytes(image);
            Directory tempDir = await getApplicationDocumentsDirectory();
            String tempPath = tempDir.path;
            var filePath = tempPath + '/$name';

            // the data
            var bytes = ByteData.view(image.buffer);
            final buffer = bytes.buffer;
            // save the data in the path
            return File(filePath).writeAsBytes(
                buffer.asUint8List(image.offsetInBytes, image.lengthInBytes));
          }
        } catch (error) {}
      }
    }).catchError((onError) {
      print('Error --->> $onError');
    });
  }
}
