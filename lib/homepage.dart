import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
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
Future<Map<String, dynamic>> reverseGeocode(double latitude, double longitude) async {
  final apiKey = 'pk.c4abc5734e15330c360f976acd611cf5'; // Replace with your LocationIQ API key
  final url = 'https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=$latitude&lon=$longitude&format=json';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    print('here is the parsed : ${parsed['display_name']}');
    return parsed;
  } else {
    throw Exception('Failed to reverse geocode coordinates');
  }
}
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
                  NavigationBarPage1(title: 'Home', display_Name: display_Name,),
                  navigationbarpage2(title: 'Search'),
                  navigationbarpage3(title: 'Wishlist'),
                  navigationbarpage4(title: 'Cart'),
                  navigationbarpage5(title: 'Profile'),
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
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'Wishlist',
              icon: Icon(Icons.favorite),
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person),
            ),
          ],
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
class NavigationBarPage1 extends StatefulWidget { 
  final String title;
  // ignore: non_constant_identifier_names
  final String? display_Name;

  // ignore: non_constant_identifier_names
  const NavigationBarPage1({super.key, required this.title, this.display_Name});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationBarPage1State createState() => _NavigationBarPage1State();
}

class _NavigationBarPage1State extends State<NavigationBarPage1> {
  String searchText = '';
  List<String> demoItems = [
    'Demo 1',
    'Demo 2',
    'Demo 3',
    'Demo 4',
    'Demo 5',
    'Demo 6',
  ];
PageController _adController = PageController();
// ignore: unused_field
late Timer _adTimer;
  List<String> advertisements = [
    'assets/demo1.png',
    'assets/demo2.png',
    'assets/demo1.png',
    'assets/demo2.png',
    'assets/demo1.png',
  ];

  @override
  void initState() {
    super.initState();
    _startRotatingAdvertisements();
    _adTimer= Timer.periodic(const Duration(seconds:6), _changeAdvertisement);
  }
void _changeAdvertisement(Timer timer) {
  if (_adController.hasClients) {
    final currentPage = _adController.page ?? 0;
    final nextPage = (currentPage + 1) % advertisements.length;
    _adController.animateToPage(nextPage.toInt(), duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
  void _startRotatingAdvertisements() {
    int currentIndex = 0;
    const duration = Duration(seconds: 3);

    Future.delayed(duration, () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % advertisements.length;
        });
        _startRotatingAdvertisements();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 40.0), // Add padding at the top
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                //'Address: $address, $states, $postcodes, $countrys',
                'Address: ${widget.display_Name}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  onChanged: (text) {
                    setState(() {
                      searchText = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchText = '';
                              });
                            },
                          )
                        : Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          // Rotating Advertisements
         
          // Grid View with Filtered Items
          Container(
            height: 300, // Adjust the height as needed
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: demoItems.length,
              itemBuilder: (context, index) {
                final item = demoItems[index];
                if (searchText.isNotEmpty &&
                    !item.toLowerCase().contains(searchText.toLowerCase())) {
                  return Container(); // Hide items that don't match the search
                }
                return _buildButton(item, 'assets/demo1.png');
              },
            ),
          ),
          SizedBox(
  height: 400, // Adjust the height as needed
  child: PageView.builder(
    controller: _adController,
    itemCount: advertisements.length,
    itemBuilder: (context, index) {
      return Image.asset(
        advertisements[index],
        fit: BoxFit.cover,
      );
    },
  ),
),
          // Horizontal Scrolling Buttons
          // Horizontal Scrolling Buttons in Two Rows
// Horizontal Scrolling Buttons in Two Rows
// Horizontal Scrolling Buttons in Two Rows
SizedBox(
  height: 150, // Adjust the height as needed
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 2, // Number of rows
    itemBuilder: (context, rowIndex) {
      return Row(
        children: [
          for (int i = rowIndex * 6 + 1; i <= (rowIndex == 0 ? 6 : 11); i++)
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding between buttons
              child: _buildButton('Button $i', 'assets/demo1.png'), // Increase the icon size
            ),
        ],
      );
    },
  ),
)


        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, String imagePath) {
    return Column(
      children: [
        IconButton(
          icon: Image.asset(imagePath),
          onPressed: () {
            // Add button functionality here
          },
        ),
        Text(buttonText),
      ],
    );
  }
}
class navigationbarpage2 extends StatelessWidget {
  final String title;

  navigationbarpage2({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to $title Page'),
    );
  }
}

class navigationbarpage3 extends StatelessWidget {
  final String title;

  navigationbarpage3({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to $title Page'),
    );
  }
}

class navigationbarpage4 extends StatelessWidget {
  final String title;

  navigationbarpage4({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to $title Page'),
    );
  }
}

class navigationbarpage5 extends StatelessWidget {
  final String title;

  navigationbarpage5({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to $title Page'),
    );
  }
}
