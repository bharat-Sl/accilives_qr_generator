import 'package:accilives_qr_generator/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class RegisterQR extends StatefulWidget {
  const RegisterQR({Key? key}) : super(key: key);

  @override
  State<RegisterQR> createState() => _RegisterQRState();
}

class _RegisterQRState extends State<RegisterQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool flashOn = false;
  bool gotData = false;
  bool loading = false;
  TextEditingController id = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
          height: size.height,
          child: Expanded(
            child: QRView(
              key: qrKey,
              cameraFacing: CameraFacing.back,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
        Positioned(
          top: size.height * 1 / 5,
          child: CustomPaint(
            foregroundPainter: BorderPainter(),
            child: Container(
              width: size.width * 2.2 / 5,
              height: size.width * 2.2 / 5,
            ),
          ),
        ),
        Positioned(
            top: size.height * 1.45 / 5,
            right: 40,
            child: InkWell(
              onTap: () async {
                await controller!.toggleFlash();
                setState(() {
                  flashOn = !flashOn;
                });
              },
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: lightPrimary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  !flashOn
                      ? Icons.flashlight_on
                      : Icons.flashlight_off_outlined,
                  color: lightPrimary,
                ),
              ),
            )),
        Positioned(
          bottom: 0,
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Text(
                  "Enter ID Manually",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: id,
                    maxLength: 22,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Paw ID(22 Characters)",
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      gotData = true;
                      loading = true;
                    });
                    Future.delayed(Duration(seconds: 5), () {
                      setState(() {
                        loading = false;
                      });
                    });
                  },
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: darkPrimary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: lightPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (loading == true)
          Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: CircularProgressIndicator(),
              )),
      ],
    );
  }

  registerUser() async {
    try {
      var val = await FirebaseFirestore.instance
          .collection("Pets")
          .doc(id.text)
          .get();
      setState(() {
        loading = false;
      });
      if (val.exists) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Id Already Exists")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registering ID")));
        FirebaseFirestore.instance
            .collection("Pets")
            .doc(id.text)
            .set({"uid": id.text});
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Some Error Occured")));
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (gotData == false) {
        result = scanData;
        setState(() {
          gotData = true;
        });
        var qrCodeResult = result!.code.toString();

        if (qrCodeResult.contains("adopted-pets-69624.web.app/pets/data")) {
          setState(() {
            id.text = qrCodeResult.split("id=")[1];
            loading = true;
          });
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              loading = false;
            });
            registerUser();
          });
        } else {
          bool _validURL = Uri.parse(qrCodeResult).isAbsolute;
          if (_validURL) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text(
                          "This QR wants to take you to ${qrCodeResult}. This is an external link and accilives has no control over it"),
                    )).then((value) => setState(() {
                  gotData = false;
                }));
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text("${qrCodeResult}"),
                    )).then((value) => setState(() {
                  gotData = false;
                }));
          }
        }
      }
    });
    controller.pauseCamera();
    controller.resumeCamera();
    flashOn = (await controller.getFlashStatus())!;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = 50; // desirable value for corners side
    double borderRadius = 20;

    Paint paint = Paint()
      ..color = lightPrimary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint shadow = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..lineTo(20, 0)
      ..quadraticBezierTo(0, 0, 0, 20)
      ..lineTo(0, cornerSide)
      ..moveTo(sw - cornerSide, 0)
      ..lineTo(sw - 20, 0)
      ..quadraticBezierTo(sw, 0, sw, 20)
      ..lineTo(sw, cornerSide)
      ..moveTo(sw - cornerSide, sh)
      ..lineTo(sw - 20, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - 20)
      ..lineTo(sw, sh - cornerSide)
      ..moveTo(cornerSide, sh)
      ..lineTo(20, sh)
      ..quadraticBezierTo(0, sh, 0, sh - 20)
      ..lineTo(0, sh - cornerSide);

    canvas.drawPath(path, shadow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
