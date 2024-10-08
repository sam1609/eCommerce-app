import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'API.dart';
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
  List<String> categories = [];
  List<Map<String, dynamic>> advertisementData = [];

   List<Map<String, dynamic>> demoButtonData = []; // New variable for demo buttons
PageController _adController = PageController();
// ignore: unused_field
late Timer _adTimer;
  List<String> advertisements = [];
Future<void> fetchAndSetCategories() async {
  List<String> newCategories = await getCategoryMultiLevel();
  setState(() {
    categories = newCategories;
  });
}
   @override
  void initState() {
    super.initState();
    _startRotatingAdvertisements();
    _adTimer = Timer.periodic(const Duration(seconds: 6), _changeAdvertisement);

    // Fetch company info first
    fetchCompanyInfo().then((_) {
      // After fetching company info, fetch slider home page data for advertisements
      fetchSliderHomePage('1').then((data) {
        setState(() {
          advertisementData = data;
          advertisements = data.map((item) => item['ProductImage'] as String).toList();
        });
      }).catchError((error) {
        print('Error fetching slider home page: $error');
      });

      // After fetching company info, fetch slider home page data for demo buttons
      fetchSliderHomePage('2').then((data) {
        setState(() {
          demoButtonData = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });

    }).catchError((error) {
      print('Error fetching company info: $error');
    });

    // Fetch categories
    fetchAndSetCategories().catchError((error) {
      print('Error fetching categories: $error');
    });
  }
 void _showDemoButtonInfo(int index) {
  _showInfo(index);  // Reuse the _showInfo method
}

void _changeAdvertisement(Timer timer) {
  if (_adController.hasClients) {
    final currentPage = _adController.page ?? 0;
    final nextPage = (currentPage + 1) % advertisements.length;
    _adController.animateToPage(nextPage.toInt(), duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
void _showInfo(int index) {
  Map<String, dynamic> data = advertisementData[index];
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoButton('Book Name: ${data['BookName']}'),
            _infoButton('Publisher: ${data['Publisher']}'),
            _infoButton('Author: ${data['Author']}'),
            _infoButton('Price: ${data['SalePrice']}'),
            // Add more fields here
          ],
        ),
      );
    },
  );
}
Widget _infoButton(String text) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  );
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
  child: Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      children: [
        Icon(Icons.location_on, color: Colors.blueAccent), // Location icon
        SizedBox(width: 8.0), // Spacing between icon and text
        Expanded( // Added Expanded
          child: Text(
            'Address: ${widget.display_Name}',
            style: TextStyle(
              fontSize: 16.0,
            ),
            softWrap: true, // Wrap the text
          ),
        ),
      ],
    ),
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
          height: 300,
          child: demoButtonData.length > 6
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: demoButtonData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showDemoButtonInfo(index),
                      child: _buildButton(
                        demoButtonData[index]['BookName'],
                        demoButtonData[index]['ProductImage'],
                      ),
                    );
                  },
                )
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: demoButtonData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showDemoButtonInfo(index),
                      child: _buildButton(
                        demoButtonData[index]['BookName'],
                        demoButtonData[index]['ProductImage'],
                      ),
                    );
                  },
                ),
        ),
          // Horizontal Scrolling Buttons
          // Horizontal Scrolling Buttons in Two Rows
// Horizontal Scrolling Buttons in Two Rows
// Horizontal Scrolling Buttons in Two Rows
SizedBox(
  height: 250, // Adjust the height as needed
  child: GridView.builder(
    scrollDirection: Axis.horizontal,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2 / 3,
      mainAxisSpacing: 0, // Adjust as needed
      crossAxisSpacing: 0, // Adjust as needed
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: _buildButton(categories[index], 'assets/demo${index + 1}.png'),
      );
    },
  ),
)




        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, String imagePath) {
  return Container(
    constraints: BoxConstraints(
      maxWidth: 100,  // Set maximum width
      maxHeight: 150, // Set maximum height
    ),
    child: Column(
      children: [
        Container(
          height: 80, // Set a fixed height for the image
          width: 80,  // Set a fixed width for the image
          child: Image.network(imagePath),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 14.0),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}}