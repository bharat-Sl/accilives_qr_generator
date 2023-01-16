import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentPosition(BuildContext context) async {
  Position? _currentPosition;
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return null;
  var val = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    _currentPosition = position;
    return _currentPosition;
  }).catchError((e) {
    print(e);
    return null;
  });

  if (val != null)
    return val;
  else
    return null;
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}
