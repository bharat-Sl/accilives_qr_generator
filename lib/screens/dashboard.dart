import 'package:accilives_qr_generator/constants/colors.dart';
import 'package:accilives_qr_generator/screens/generate_qr.dart';
import 'package:accilives_qr_generator/screens/manual_qr.dart';
import 'package:accilives_qr_generator/screens/register_qr.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    if (!(await Permission.camera.isGranted)) await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primary,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 10,
          title: Text(
            "Adopted Tails",
            style: TextStyle(color: dark),
          ),
        ),
        body: [
          GenerateQR(),
          ManualQR(),
          RegisterQR(),
        ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'Gen QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2),
              label: 'Custom QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Validate QR',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: darkPrimary,
          unselectedItemColor: lightPrimary.withOpacity(0.8),
          elevation: 10,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
