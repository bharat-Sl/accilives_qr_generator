import 'dart:io';
import 'dart:ui';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

downloadQrCode(Uint8List screenshot, String name) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
    return "Storage permission not given! Please give permission from settings and if allowed, ignore the message";
  } else {
    final path = Directory("/storage/emulated/0/Download/PetQR");
    if ((await path.exists())) {
      final directory = "/storage/emulated/0/Download/PetQR";
      if (screenshot != null) {
        try {
          final imagePath = await File('$directory/$name.png').create();
          if (imagePath != null) {
            await imagePath.writeAsBytes(screenshot);
            return null;
          }
        } catch (error) {
          return "Some error occured! Contact IT department to know further details";
        }
      }
    } else {
      path.create();
      return "Folder not found! Creating folder now, please retry again.";
    }
  }
}
