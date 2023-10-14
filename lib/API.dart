import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter/material.dart';

const String apiurl="https://ecommerceapi.cloudpub.in";
const String accessCode='TxBmrWQQtOdSlo2uBEpoKYb5kBX+wBaiR7SWUu3WgAk=';
// final String iCompanyID ='1';
// final String BranchID = '1';
  String username = '-11';
  String password = 'DC6F7CCB2DAD40BB9AF09BBFF07C273A';
  String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
String? companyid;
String? branchid;
String? signupvia;
String? companyname;
String? financialperiod;

String strUserID='WEB_4';
// Future<Map<String, dynamic>> WebGetCompanyDetail() async {
 
//   final url = apiurl+'/api/WebCompanyInfo?accessCode='+accessCode;

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final parsed = jsonDecode(response.body);
//     print('here is the parsed : $parsed');
//     return parsed;
//   } else {
//     throw Exception('Failed to reverse geocode coordinates');
//   }
// }
Future<void> fetchCompanyInfo() async {
  const String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebCompanyInfo?accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body)[0];
    companyid = data['iCompanyId'].toString();
    branchid = data['iBranchID'].toString();
    signupvia=data['SignUpVia'].toString();
     companyname=data['CompanyName'].toString();
        financialperiod=data['FinancialPeriod'].toString();
        // print('The output is : $companyid$branchid$signupvia$companyname$financialperiod');
  } else {
    throw Exception('Failed to fetch data');
  }
}
// ignore: non_constant_identifier_names
Future<List<Map<String, dynamic>>> fetchSliderHomePage(String sliderseq) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebGetSliderHomePage?iCompanyID=${companyid.toString()}&iBranchID=${branchid.toString()}&accessCode=$accessCode&SLiderSeq=${sliderseq.toString()}';
  // print('Here is company id: $companyid');
  //  print('Here is branch id: $branchid');
  //  print(accessCode);
  final Uri uri = Uri.parse(apiUrl);
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    // print('hausd ::: $uri');
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<Map<String, dynamic>>> searchbarapi(String searchtext) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebTitleSearchData?websearchtype=&websearchText=$searchtext&Searchsubjectlist=&SearchsubjectlistID=&OtherCountry=INDIA&iCompanyID=1&iBranchID=1&PublisherID=&AuthorID=&LanguageID=&TitleCategoryID=&Edition=&SearchSubsubjectlistID=&TitleSubCategoryID=&PublishYear=&Binding=&TotalRecord=&Sortby=&sortingAcenDesc=&SiteName=&SchoolCode=&MinPrice=&MaxPrice=&ExcludeOutofStock=&InterestAgeGroup=&BookClass=&BookMedium=&CourseID=&ClassID=&accessCode=TxBmrWQQtOdSlo2uBEpoKYb5kBX+wBaiR7SWUu3WgAk=&PageNumber=1&PageSize=1000';
  // print('Here is company id: $companyid');
  //  print('Here is branch id: $branchid');
  //  print(accessCode);
  final Uri uri = Uri.parse(apiUrl);
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    print('hausd fake200::: $uri');
    print(response.body);
    print(response.statusCode);
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    print('hausd fake fail::: $uri');
    print(response.body);
    print(response.statusCode);
    throw Exception('Failed to fetch data');
  }
}

Future<List<String>> getCategoryMultiLevel() async {
  String apiUrl = '$apiurl/api/WebGetmultiLevelCategoryOfItem';
  final Uri uri = Uri.parse('$apiUrl?striCompanyID=$companyid&accessCode=$accessCode');

  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

 List<String> categories = [];
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    categories = List<String>.from(data.map((item) => item['CategoryDesc']));
  }
  //print('here is the output of categories: $categories');
  return categories;
}

Future<Map<String, dynamic>> reverseGeocode(double latitude, double longitude) async {
  final apiKey = 'pk.c4abc5734e15330c360f976acd611cf5'; // Replace with your LocationIQ API key
  final url = 'https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=$latitude&lon=$longitude&format=json';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    //print('here is the parsed : ${parsed['display_name']}');
    return parsed;
  } else {
    throw Exception('Failed to reverse geocode coordinates');
  }
}

Future<List<Map<String, dynamic>>> webGetUserCart() async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebGetUserCart?iCompanyID=$companyid&iBranchID=$branchid&strOtherCountry=0&strCustomerCode=$strUserID&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  // print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}


Future<List<Map<String, dynamic>>> webInsertUserCart(String bookcode, String bookquantity) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebInsertUserCart?strCustomerCode=$strUserID&strBookCode=$bookcode&strBookQty=$bookquantity&strBookClubID=0&iCompanyID=$companyid&iBranchID=$branchid&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  // print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}


Future<List<Map<String, dynamic>>> webDeleteUserCartandItem(String bookcode, String customercode, String cartid) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebDeleteUserCartandItem?iCompanyID=$companyid&iBranchID=$branchid&strBookCode=$bookcode&strCustomerCode=$customercode&strCartID=$cartid&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  // print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
// print('look here fast : $uri');
  if (response.statusCode == 200) {
    // print('delete initiated');
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}



Future<List<Map<String, dynamic>>> webUpdateUserCart(String bookcode, String customercode, String cartid, String newquantity) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebUpdateUserCart?iCompanyID=$companyid&iBranchID=$branchid&strBookCode=$bookcode&strCustomerCode=$customercode&strCartID=$cartid&strBookQty=$newquantity&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  // print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
// print('look here fast : $uri');
  if (response.statusCode == 200) {
    // print('Update initiated');
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}


Future<List<Map<String, dynamic>>> webGetSimilarBooks(String bookcode) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebGetSimilarBooks?iCompanyID=$companyid&iBranchID=$branchid&strOtherCountry=INDIA&strBookCode=$bookcode&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
print('look here fast : $uri');
  if (response.statusCode == 200) {
    print('Update initiated');
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}



Future<List<Map<String, dynamic>>> webGetUserCartandWishlistCount() async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebGetUserCartandWishlistCount?strUserID=$strUserID&iCompanyID=$companyid&iBranchID=$branchid&accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  print('Here is final url: $uri');
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
print('look here fast : $uri');
  if (response.statusCode == 200) {
    print('Update initiated');
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String websearchText = '';
  Future<List<Map<String, dynamic>>>? futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                setState(() {
                  websearchText = text;
                  futureData = searchbarapi(websearchText);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: websearchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            websearchText = '';
                          });
                        },
                      )
                    : Icon(Icons.search),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data found');
                  } else {
                    return GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    var item = snapshot.data![index];
    return GestureDetector(
      onTap: () => _showBookDetails(context, item),
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: item['ImgPath'] != null || item['ImagePath'] != null
                  ? Image.network(
                      item['ImgPath'] ?? item['ImagePath'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(); // Empty space if image fails to load
                      },
                    )
                  : SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['BookName'].length > 30
                        ? item['BookName'].substring(0, 30) + '...'
                        : item['BookName'],
                  ),
                  Text(
                    'Price: ${item['SalePrice'].toString().length > 30 ? item['SalePrice'].toString().substring(0, 30) + '...' : item['SalePrice']}',
                  ),
                  Text(
                    'Author: ${item['Author'].length > 30 ? item['Author'].substring(0, 30) + '...' : item['Author']}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  },
);

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Include your _showBookDetails function here or import it from a common file

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
                              TableCell(child: _infoText(book['ProductID'].toString())), // Convert to String
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
        ' -${book['DiscountPercent'].toString()}% ',
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
        final result = await webInsertUserCart(book['ProductID'], quantity.toString());
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
