import 'package:accilives_qr_generator/constants/colors.dart';
import 'package:accilives_qr_generator/functions/qr_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

import 'package:screenshot/screenshot.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String random = getRandomString(16);
  int val = 1;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Container(
            width: size.width,
            child: InkWell(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 20,
                    child: Row(
                      children: [
                        Text("Number of QRs:  "),
                        DropdownButton<int>(
                          value: val,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          menuMaxHeight: 200,
                          onChanged: (int? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              val = value!;
                            });
                          },
                          items: [for (var i = 0; i <= 100; i += 1) i]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        width: size.width * 0.8,
                        height: size.width * 0.9,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: darkPrimary.withOpacity(0.2),
                                  blurRadius: 10)
                            ]),
                        child: Column(
                          children: [
                            QrImage(
                              foregroundColor: darkPrimary,
                              data:
                                  "https://adopted-pets-69624.web.app/pets/data?id=${random}",
                              version: QrVersions.auto,
                              size: size.width * 0.7,
                            ),
                            Text(
                              random,
                              style: TextStyle(
                                  color: darkPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: InkWell(
                      onTap: () async {
                        var i;
                        for (i = 0; i < val; i++) {
                          var capture = await screenshotController.capture();
                          if (capture != null) {
                            var resp = await downloadQrCode(capture, random);
                            if (resp != null) {
                              EasyLoading.showInfo(resp);
                            } else {
                              EasyLoading.showSuccess(
                                  "Downloaded Successfully! Regenerating QR");
                              setState(() {
                                random = getRandomString(16);
                              });
                            }
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.qr_code_scanner_rounded),
                          Text(
                            "Download QR",
                            style: TextStyle(
                                color: darkPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
