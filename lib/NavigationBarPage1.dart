import 'package:flutter/material.dart';
import 'dart:async';
import 'NavigationBarPage5.dart';
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
 List<Map<String, dynamic>> demoButtonData2 = []; 
//  List<Map<String, dynamic>> demoButtonData2 = []; 
 List<Map<String, dynamic>> demoButtonData3 = []; 
 List<Map<String, dynamic>> demoButtonData4 = []; 
 List<Map<String, dynamic>> demoButtonData5 = []; 
 List<Map<String, dynamic>> demoButtonData6 = [];
 List<Map<String, dynamic>> demoButtonData8 = [];  
PageController _adController = PageController();

// ignore: unused_field
late Timer _adTimer;
  List<String> advertisements = [];
Future<void> fetchAndSetCategories() async {
  List<String> newCategories = await getCategoryMultiLevel('1');
  setState(() {
    categories = newCategories;
  });
}
   @override
  void initState() {
    super.initState();
    _startRotatingAdvertisements();
    _adTimer = Timer.periodic(const Duration(seconds: 6), _changeAdvertisement);

    // Fetch company info and slider home page data
    fetchCompanyInfo().then((_) {
      fetchSliderHomePage('1').then((data) {
        setState(() {
          advertisementData = data;
          advertisements = data.map((item) => item['ProductImage'] as String).toList();
        });
        
      }).catchError((error) {
        print('Error fetching slider home page: $error');
      });
    fetchSliderHomePage('2').then((data) {
        setState(() {
          demoButtonData2 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchSliderHomePage('3').then((data) {
        setState(() {
          demoButtonData3 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchSliderHomePage('4').then((data) {
        setState(() {
          demoButtonData4 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchSliderHomePage('5').then((data) {
        setState(() {
          demoButtonData5 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchSliderHomePage('6').then((data) {
        setState(() {
          demoButtonData6 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchSliderHomePage('8').then((data) {
        setState(() {
          demoButtonData8 = data;
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
 void _showDemoButtonInfo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData2),
      ),
    );
  }
// void _showDemoButtonInfo2() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BooksListPage(bookData: advertisementData),
//       ),
//     );
//   }
  void _showDemoButtonInfo3() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData3),
      ),
    );
  }void _showDemoButtonInfo4() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData4),
      ),
    );
  }void _showDemoButtonInfo5() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData5),
      ),
    );
  }void _showDemoButtonInfo6() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData6),
      ),
    );
  }void _showDemoButtonInfo8() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BooksListPage(bookData: demoButtonData8),
      ),
    );
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
  int quantity = 1; // Initialize quantity to 0

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoButton('Product ID: ${data['ProductId']}'),
                _infoButton('Book Name: ${data['BookName']}'),
                _infoButton('Publisher: ${data['Publisher']}'),
                _infoButton('Author: ${data['Author']}'),
                _infoButton('Price: ${data['SalePrice']}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 0) {
                                quantity--;
                              }
                            });
                          },
                        ),
                        Text('Quantity: $quantity'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(quantity!=0) {
                          Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NavigationBarPage5(
                            title: 'Cart',
                            productData: data,
                            quantity: quantity,
                          ),
                        ));
                        }
                         //Navigator.pop(context); // Close the modal
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => NavigationBarPage5(title: 'Cart'),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: quantity > 0 ? Colors.blue: Colors.white,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: quantity > 0 ?  Colors.white:Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
  //         Padding(
  // padding: const EdgeInsets.all(16.0), // Add the desired padding values
  // child:
  //         Container(
  //         height: 330,
  //         child: demoButtonData.length > 6
  //             ? ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: demoButtonData.length,
  //                 itemBuilder: (context, index) {
  //                   return GestureDetector(
  //                     onTap: () => _showDemoButtonInfo(index),
  //                     child: _buildButton2(
  //                       demoButtonData[index]['BookName'],
  //                       demoButtonData[index]['ProductImage'],
  //                     ),
  //                   );
  //                 },
  //               )
  //             : GridView.builder(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 3,
  //                 ),
  //                 itemCount: demoButtonData.length,
  //                 itemBuilder: (context, index) {
  //                   return GestureDetector(
  //                     onTap: () => _showDemoButtonInfo(index),
  //                     child: _buildButton2(
  //                       demoButtonData[index]['BookName'],
  //                       demoButtonData[index]['ProductImage'],
  //                     ),
  //                   );
  //                 },
  //               ),
  //       ),),
       Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      SizedBox(
        height: 160, // Adjust the height as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use this to distribute buttons evenly
          children: [
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo),
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo3),
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo4),
          ],
        ),
      ),
      SizedBox(
        height: 160, // Adjust the height as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use this to distribute buttons evenly
          children: [
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo5),
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo6),
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo8),
          ],
        ),
      ),
    ],
  ),
),



          SizedBox(
  height: 450,
  child: PageView.builder(
    controller: _adController,
    itemCount: advertisements.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () => _showInfo(index),
        child: Image.network(
          advertisements[index],
          fit: BoxFit.cover,
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
  return Column(
    children: [
      IconButton(
        icon: Image.asset(imagePath),
        iconSize: 50.0, // Increase the icon size
        onPressed: () {
          // Add button functionality here
        },
      ),
      Text(
        buttonText,
        style: TextStyle(fontSize: 18.0), // Increase the text size
      ),
    ],
  );
}

Widget _buildButton2(String buttonText, String imagePath) {
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
}Widget _buildDemoButton(String imagePath, Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            child: Image.asset(imagePath),
          ),
          Text(
            'Demo Button',
            style: TextStyle(fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }}

class DemoContentPage extends StatelessWidget {
  final String category;
  final List<String> items;

  DemoContentPage({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // Build your content here based on 'item'
          return ListTile(
            title: Text(item),
          );
        },
      ),
    );
  }
}
class BooksListPage extends StatelessWidget {
  final List<Map<String, dynamic>> bookData; // Replace with your actual data

  BooksListPage({required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items in a row
        ),
        itemCount: bookData.length,
        itemBuilder: (context, index) {
          final book = bookData[index];
          return GestureDetector(
            onTap: () => _showBookDetails(context, book),
            child: Card(
              child: Column(
                children: [
                  Image.network(
                    book['ProductImage'],
                    width: 100, // Adjust the image size as needed
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(book['BookName']),
                    // Add other book information here if needed
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBookDetails(BuildContext context, Map<String, dynamic> book) {
    int quantity = 1; // Initialize quantity to 1

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoButton('Product ID: ${book['ProductId']}'),
                  _infoButton('Book Name: ${book['BookName']}'),
                  _infoButton('Publisher: ${book['Publisher']}'),
                  _infoButton('Author: ${book['Author']}'),
                  _infoButton('Price: ${book['SalePrice']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 0) {
                                  quantity--;
                                }
                              });
                            },
                          ),
                          Text('Quantity: $quantity'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (quantity != 0) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NavigationBarPage5(
                                  title: 'Cart',
                                  productData: book,
                                  quantity: quantity,
                                ),
                              ),
                            );
                          }
                          Navigator.pop(context); // Close the modal
                        },
                        style: ElevatedButton.styleFrom(
                          primary: quantity > 0 ? Colors.blue : Colors.white,
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: quantity > 0 ? Colors.white : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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
}