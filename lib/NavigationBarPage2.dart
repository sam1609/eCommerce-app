import 'package:flutter/material.dart';
import 'dart:async';
// import 'NavigationBarPage5.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'API.dart';
class NavigationBarPage2 extends StatefulWidget { 
  final String title;
  // ignore: non_constant_identifier_names
  final String? display_Name;

  // ignore: non_constant_identifier_names
  const NavigationBarPage2({super.key, required this.title, this.display_Name});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationBarPage2State createState() => _NavigationBarPage2State();
}

class _NavigationBarPage2State extends State<NavigationBarPage2> {
   Future<void>? fetchDemoButtonData2;
  Future<void>? fetchDemoButtonData3;
   Future<void>? fetchDemoButtonData4;
  Future<void>? fetchDemoButtonData5;
   Future<void>? fetchDemoButtonData6;
  Future<void>? fetchDemoButtonData8;
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
    fetchDemoButtonData2 = fetchSliderHomePage('2').then((data) {
        setState(() {
          demoButtonData2 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchDemoButtonData3 =fetchSliderHomePage('3').then((data) {
        setState(() {
          demoButtonData3 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchDemoButtonData4 =fetchSliderHomePage('4').then((data) {
        setState(() {
          demoButtonData4 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchDemoButtonData5 =fetchSliderHomePage('5').then((data) {
        setState(() {
          demoButtonData5 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchDemoButtonData6 =fetchSliderHomePage('6').then((data) {
        setState(() {
          demoButtonData6 = data;
        });
      }).catchError((error) {
        print('Error fetching demo button data: $error');
      });
      fetchDemoButtonData8 =fetchSliderHomePage('8').then((data) {
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
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.network(data['ImagePath'] ?? '', fit: BoxFit.cover),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // Adjust the column widths as needed
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Product ID:')),
                              TableCell(child: _infoText(data['ProductId'].toString())), // Convert to String
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Book Name:')),
                              TableCell(child: _infoText(data['BookName'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Publisher:')),
                              TableCell(child: _infoText(data['Publisher'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Author:')),
                              TableCell(child: _infoText(data['Author'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Price:')),
                            TableCell(
  child: Row(
    children: [
      Text(
        data['SalePrice'].toString(),
        style: TextStyle(
          color: Colors.grey,
          decoration: TextDecoration.lineThrough, // Add strike-through
        ),
      ),
      Text(
        ' -${data['SaleDiscount'].toString()}% ',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      Text(
        '${data['SaleCurrency']} ${data['DiscountPrice'].toString()}',
        style: TextStyle(
        ),
      ),
    ],
  ),
),


                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
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
                      onPressed: () async {
                        // Your code for adding to cart here
    if (quantity > 0) {
      try {
        final result = await webInsertUserCart(data['ProductId'], quantity.toString());
        // Check the result and provide user feedback if needed
      if (result.isNotEmpty) {
  // Show a SnackBar at the top right of the screen
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(result[0]['Result']),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // Set behavior to floating
      margin: EdgeInsets.only(top: 16.0, right: 16.0), // Adjust margin
    ),
  );

  print('look here : ${result[0]['Result']}');
}
 else {
          // Handle the case where the API call was successful, but the item was not added
          print('Item not added to the cart. Check the response.');
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        print('Error adding item to cart: $e');
        // print('here is the product id: ${data['ProductId']}');
        // print('here is the quantity : $quantity');
      }
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
                    // const SizedBox(height:100),
                    // const Text('View similar Books: '),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _infoText(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
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
//           Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: Container(
//     padding: EdgeInsets.all(8.0),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.blueAccent),
//       borderRadius: BorderRadius.circular(12.0),
//     ),
//     child: Row(
//       children: [
//         Icon(Icons.location_on, color: Colors.blueAccent), // Location icon
//         SizedBox(width: 8.0), // Spacing between icon and text
//         Expanded( // Added Expanded
//           child: Text(
//             'Address: ${widget.display_Name}',
//             style: TextStyle(
//               fontSize: 16.0,
//             ),
//             softWrap: true, // Wrap the text
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
Row(
  children: <Widget>[
    SizedBox(width: 5.0),  // Optional: to give some spacing between the icon and text
    Image.asset('assets/beauty.png', height: 24, width: 24),  // Adjust height and width accordingly
    Text('Personal grooming', style: TextStyle(fontSize: 24.0)),
  ],
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
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo,fetchDemoButtonData2,'2'),
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo3,fetchDemoButtonData3,'3'),
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo4,fetchDemoButtonData4,'4'),
          ],
        ),
      ),
      SizedBox(
        height: 160, // Adjust the height as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Use this to distribute buttons evenly
          children: [
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo5,fetchDemoButtonData5,'5'),
            _buildDemoButton('assets/demo1.png', _showDemoButtonInfo6,fetchDemoButtonData6,'6'),
            _buildDemoButton('assets/demo2.png', _showDemoButtonInfo8,fetchDemoButtonData8,'8'),
          ],
        ),
      ),
    ],
  ),
),



          SizedBox(
          height: 450,
          child: advertisements.isEmpty // Check if advertisements is empty
              ? Center(
                  child: Text('Loading...'), // Display loading text if data is still loading
                )
              : PageView.builder(
                  controller: _adController,
                  itemCount: advertisements.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showInfo(index),
                      child: Image.network(
                        advertisements[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                      ),
                    );
                  },
                )),
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
}Widget _buildDemoButton(String imagePath, Function()? onPressed, Future<void>? fetchData, String name) {
    return GestureDetector(
      onTap: onPressed,
      child: FutureBuilder<void>(
        future: fetchData,  // pass the specific Future variable here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Loading data...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset(imagePath),
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
        },
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
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.network(book['ImagePath'] ?? '', fit: BoxFit.cover),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // Adjust the column widths as needed
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Product ID:')),
                              TableCell(child: _infoText(book['ProductId'].toString())), // Convert to String
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Book Name:')),
                              TableCell(child: _infoText(book['BookName'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Publisher:')),
                              TableCell(child: _infoText(book['Publisher'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Author:')),
                              TableCell(child: _infoText(book['Author'])),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(child: _infoText('Price:')),
                            TableCell(
  child: Row(
    children: [
      Text(
        book['SalePrice'].toString(),
        style: TextStyle(
          color: Colors.grey,
          decoration: TextDecoration.lineThrough, // Add strike-through
        ),
      ),
      Text(
        ' -${book['SaleDiscount'].toString()}% ',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      Text(
        '${book['SaleCurrency']} ${book['DiscountPrice'].toString()}',
        style: TextStyle(
        ),
      ),
    ],
  ),
),


                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
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
                      onPressed: () async {
                        // Your code for adding to cart here
    if (quantity > 0) {
      try {
        final result = await webInsertUserCart(book['ProductId'], quantity.toString());
        // Check the result and provide user feedback if needed
      if (result.isNotEmpty) {
  // Show a SnackBar at the top right of the screen
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(result[0]['Result']),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // Set behavior to floating
      margin: EdgeInsets.only(top: 16.0, right: 16.0), // Adjust margin
    ),
  );

  print('look here : ${result[0]['Result']}');
}
 else {
          // Handle the case where the API call was successful, but the item was not added
          print('Item not added to the cart. Check the response.');
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        print('Error adding item to cart: $e');
        // print('here is the product id: ${data['ProductId']}');
        // print('here is the quantity : $quantity');
      }
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
                    // const SizedBox(height:100),
                    // const Text('View similar Books: '),
              ],
            ),
          );
        },
      );
    },
  );
}
Widget _infoText(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  );
}
}