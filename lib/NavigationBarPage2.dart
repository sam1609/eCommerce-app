import 'package:flutter/material.dart';
import 'dart:async';
class NavigationBarPage2 extends StatefulWidget {
  final String pageTitle;
  final String? displayName;

  const NavigationBarPage2({Key? key, required this.pageTitle, this.displayName})
      : super(key: key);

  @override
  _NavigationBarPage2State createState() => _NavigationBarPage2State();
}

class _NavigationBarPage2State extends State<NavigationBarPage2> {
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
    _adTimer = Timer.periodic(const Duration(seconds: 6), _changeAdvertisement);
  }

  void _changeAdvertisement(Timer timer) {
    if (_adController.hasClients) {
      final currentPage = _adController.page ?? 0;
      final nextPage = (currentPage + 1) % advertisements.length;
      _adController.animateToPage(nextPage.toInt(),
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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
        padding: EdgeInsets.only(top: 40.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.favorite),
                SizedBox(width: 8.0),
                Text(
                  'Personal grooming',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
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
          // Wrap the GridView.builder with NeverScrollableScrollPhysics
          Container(
            height: 300,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: demoItems.length,
              itemBuilder: (context, index) {
                final item = demoItems[index];
                if (searchText.isNotEmpty &&
                    !item.toLowerCase().contains(searchText.toLowerCase())) {
                  return Container();
                }
                return _buildButton(item, 'assets/demo1.png');
              },
            ),
          ),
          SizedBox(
            height: 400,
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
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, rowIndex) {
                return Row(
                  children: [
                    for (int i = rowIndex * 6 + 1;
                        i <= (rowIndex == 0 ? 6 : 11);
                        i++)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildButton('Button $i', 'assets/demo1.png'),
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