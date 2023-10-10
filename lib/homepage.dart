import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'NavigationBarPage1.dart';
import 'NavigationBarPage2.dart';
import 'NavigationBarPage3.dart';
import 'NavigationBarPage4.dart';
import 'NavigationBarPage5.dart';
import 'API.dart';
Future<int> getCartItemQtyCount() async {
  try {
    final List<Map<String, dynamic>> response = await webGetUserCartandWishlistCount();
    
    // Check if the response contains data and is not empty
    if (response.isNotEmpty) {
      final int cartItemQtyCount = response[0]['CartItemQtyCount'];
      return cartItemQtyCount;
    } else {
      // Handle the case when the response is empty or doesn't contain the expected data
      throw Exception('Failed to get CartItemQtyCount');
    }
  } catch (e) {
    // Handle any exceptions that might occur during the HTTP request
    print('Error getting CartItemQtyCount: $e');
    throw Exception('Failed to get CartItemQtyCount');
  }
}
//import 'package:google_maps_flutter/google_maps_flutter.dart';

// Future<List<dynamic>> fetchNearbyPlaces(double latitude, double longitude) async {
//   final apiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
//   final radius = 1000; // You can adjust the radius as needed
//   final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//       '?location=$latitude,$longitude'
//       '&radius=$radius'
//       '&key=$apiKey';

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final parsed = jsonDecode(response.body);
//     return parsed['results'];
//   } else {
//     throw Exception('Failed to load nearby places');
//   }
// }

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
  int _currentIndex = 0;
  late PageController _pageController;

  // Define latitude and longitude here
  double latitude = 0.0; // Replace with your default values
  double longitude = 0.0; // Replace with your default values
String address = '';
String states = '';
String postcodes = '';
String countrys = '';
String display_Name='';
  @override
  void initState() {
    super.initState();
    _checkLocationService();
    _pageController = PageController(initialPage: _currentIndex);
     _fetchUserLocation();
  }
Future<void> _fetchUserLocation() async {
  await _checkLocationService();
  reverseGeocodeCoordinates();
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
 LocationData locationData = await location.getLocation();
  latitude = locationData.latitude!;
  longitude = locationData.longitude!;
  print('Current Location: Latitude $latitude, Longitude $longitude');
}

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    reverseGeocodeCoordinates();
  }
// Your reverse geocoding function
Future<void> reverseGeocodeCoordinates() async {
  try {
    final result = await reverseGeocode(latitude, longitude);
    final displayName =result['display_name'];
    final stateDistrict= result['address']['state_district'];
    final state = result['address']['state'];
    final postcode = result['address']['postcode'];
    final country = result['address']['country'];
    setState(() {
      display_Name=displayName;
      address = stateDistrict;
      states=state;
      postcodes=postcode;
      countrys=country;
    });
  } catch (e) {
    print('Error reverse geocoding: $e');
  }
}

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: null,
        body: Column(
          children: [
             SizedBox(height: 40),
            // Expanded(
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: LatLng(latitude, longitude), // Use the user's location here
            //       zoom: 14.0,
            //     ),
            //     onMapCreated: (GoogleMapController controller) {
            //       // You can perform actions on the map controller here if needed
            //     },
            //   ),
            // ),

//sending address to every page 

            //  Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     //'Address: $address, $states, $postcodes, $countrys',
            //     'Address: $display_Name',
            //     style: TextStyle(fontSize: 16.0),
            //   ),
            // ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  NavigationBarPage1(title: 'UC', display_Name: display_Name),
                  NavigationBarPage2(pageTitle: 'Beauty', displayName: display_Name),
                  NavigationBarPage3(pageTitle: 'Homes', displayName: display_Name),
                  NavigationBarPage4(pageTitle: 'Shop', displayName: display_Name),
                  NavigationBarPage5(title: 'Cart'),
                ],
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.black, // Set selected item color to black
          unselectedItemColor: Colors.black, // Set unselected item color to black
          items: [
  BottomNavigationBarItem(
    label: 'UC',
    icon: Icon(Icons.home),
  ),
  BottomNavigationBarItem(
    label: 'Beauty',
    icon: Icon(Icons.favorite), // You can change this icon to a beauty-related icon
  ),
  BottomNavigationBarItem(
    label: 'Homes',
    icon: Icon(Icons.house), // You can change this icon to a house-related icon
  ),
  BottomNavigationBarItem(
    label: 'Shop',
    icon: Icon(Icons.shopping_bag), // You can change this icon to a shopping-related icon
  ),
  BottomNavigationBarItem(
  label: 'Cart',
  icon: Stack(
    children: [
      Icon(Icons.shopping_cart),
      Positioned(
        right: 0,
        top: 0,
        child: FutureBuilder<int>(
          future: getCartItemQtyCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Return a loading indicator while waiting for the data
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              );
            } else if (snapshot.hasError) {
              // Handle the error state
              return Container(); // You can customize the error UI here
            } else if (snapshot.hasData && snapshot.data! > 0) {
              // Display the red filled circle with cartItemQtyCount
              return Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  snapshot.data.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              );
            } else {
              // If cartItemQtyCount is 0, don't display the circle
              return Container();
            }
          },
        ),
      ),
    ],
  ),
)

]
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


