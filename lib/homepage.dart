import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  final String? dialCode;
  final String? phoneNumber;

  HomePage(this.dialCode, this.phoneNumber);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBackPressed = false;
  Location location = Location();
  bool _locationServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    _locationServiceEnabled = await location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await location.requestService();
      if (!_locationServiceEnabled) {
        // Handle the case where the user doesn't enable location services.
        print('Location services are disabled');
        return;
      }
    }

    // Location services are enabled, now you can fetch the current location.
    LocationData locationData = await location.getLocation();
    double latitude = locationData.latitude!;
    double longitude = locationData.longitude!;
    print('Current Location: Latitude $latitude, Longitude $longitude');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Home Page'),
              Text('Dial Code: ${widget.dialCode}'),
              Text('Phone Number: ${widget.phoneNumber}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_isBackPressed) {
      return true; // Allow the app to exit
    } else {
      _isBackPressed = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit the app'),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset _isBackPressed after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        _isBackPressed = false;
      });

      return false; // Prevent the app from exiting
    }
  }
}
