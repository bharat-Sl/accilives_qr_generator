import 'package:accilives_qr_generator/constants/colors.dart';
import 'package:accilives_qr_generator/functions/qr_share.dart';
import 'package:flutter/material.dart';
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
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var random = getRandomString(16);
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: primary,
                image: DecorationImage(
                    opacity: 0.2,
                    image: NetworkImage(
                      "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/cute-cat-photos-1593441022.jpg?crop=0.670xw:1.00xh;0.167xw,0&resize=640:*",
                    ),
                    fit: BoxFit.cover),
              ),
              child: InkWell(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).viewPadding.top + 10,
                            bottom: 40,
                            left: 30,
                            right: 30),
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.arrow_back_sharp,
                                color: dark,
                                size: 30,
                              ),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: dark,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Container(
                          width: size.width * 0.8,
                          height: size.width * 0.9,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                                    "https://www.adoptedtails.com/pets/data?id=${random}",
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
                        onTap: () {
                          shareQrCode(screenshotController, random);
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
      ),
    );
  }
}
