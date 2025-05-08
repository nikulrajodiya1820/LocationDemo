// ignore_for_file: camel_case_types, prefer_const_constructors, duplicate_ignore, unused_import, unused_element, unused_field, unnecessary_new, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getLocation(),
    );
  }
}

class getLocation extends StatefulWidget {
  const getLocation({Key? key}) : super(key: key);

  @override
  _getLocationState createState() => _getLocationState();
}

class _getLocationState extends State<getLocation> {
  Location location = new Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 50,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              'Get User Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(""),
            ElevatedButton(
                onPressed: () {
                  location.enableBackgroundMode(enable: true);
                  location.onLocationChanged
                      .listen((LocationData currentLocation) {
                    Fluttertoast.showToast(
                      msg: (currentLocation.latitude.toString()),
                    );
                  });
                },
                child: Text("Get Current Location"))
          ],
        ),
      ),
    );
  }
}
