import 'package:accilives_qr_generator/constants/colors.dart';
import 'package:accilives_qr_generator/functions/qr_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

import 'package:screenshot/screenshot.dart';

class ManualQR extends StatefulWidget {
  const ManualQR({Key? key}) : super(key: key);

  @override
  State<ManualQR> createState() => _ManualQRState();
}

class _ManualQRState extends State<ManualQR> {
  String gen = "";
  TextEditingController text = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Container(
            width: size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 20,
                  width: size.width - 60,
                  child: Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          const BoxShadow(
                              color: Color(0xffc6ac8f),
                              blurRadius: 5,
                              offset: Offset(0, 1))
                        ]),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: text,
                      maxLines: 1,
                      maxLength: 16,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9]')),
                      ],
                      decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter Id (16 Character)"),
                      onChanged: (str) {
                        setState(() {
                          gen = str;
                        });
                      },
                    ),
                  ),
                ),
                if (gen.length == 16)
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
                                  "https://adopted-pets-69624.web.app/pets/data?id=${gen}",
                              version: QrVersions.auto,
                              size: size.width * 0.7,
                            ),
                            Text(
                              gen,
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
                if (gen.length == 16)
                  Positioned(
                    bottom: 20,
                    child: InkWell(
                      onTap: () async {
                        var capture = await screenshotController.capture();
                        if (capture != null) {
                          var resp = await downloadQrCode(capture, gen);
                          if (resp != null) {
                            EasyLoading.showInfo(resp);
                          } else {
                            EasyLoading.showSuccess(
                                "Downloaded Successfully! Regenerating QR");
                            setState(() {
                              gen = "";
                              text.text = "";
                            });
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
      ],
    );
  }
}
