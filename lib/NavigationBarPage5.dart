// slide and button both 

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'API.dart'; // Import the file containing webGetUserCart function
import 'dart:async'; // Import to work with Futures
import 'formpage.dart';
// import 'package:flutter/widgets.dart'; // Import to use Image widget
String strUserID='WEB_4';
class NavigationBarPage5 extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? productData;
  final int? quantity;

  const NavigationBarPage5({
    Key? key,
    required this.title,
    this.productData,
    this.quantity,
  }) : super(key: key);

  @override
  _NavigationBarPage5State createState() => _NavigationBarPage5State();
}

class _NavigationBarPage5State extends State<NavigationBarPage5> {
  List<Map<String, dynamic>>? cartData;
  bool isLoading = true;
 @override
  void initState() {
    super.initState();
    _fetchUserCart();
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserCart();
  }
 Future<void> _fetchUserCart() async {
    try {
      final cart = await webGetUserCart(); // Call the API function
      setState(() {
        cartData = cart;
        isLoading = false; // Set isLoading to false when data is loaded
      });
    } catch (e) {
      // Handle the error here (e.g., show an error message)
      print('Error fetching cart data: $e');
      setState(() {
        isLoading = false; // Set isLoading to false on error as well
      });
    }
  }
  //  Future<void> _fetchupdates(String bookcode, String customercode, String cartid, String newquantity) async {
  //   try {
  //     final cart = await webUpdateUserCart(bookcode,customercode,cartid,newquantity); // Call the API function
  //     setState(() {
  //       cartData = cart;
  //       isLoading = false; // Set isLoading to false when data is loaded
  //     });
  //   } catch (e) {
  //     // Handle the error here (e.g., show an error message)
  //     print('Error updating cart data: $e');
  //     setState(() {
  //       isLoading = false; // Set isLoading to false on error as well
  //     });
  //   }
  // }
// Future<void> _deleteItem(int productID, String cartID) async {
//   try {
//     // Convert productID to a string
//     String productIDString = productID.toString();
    
//     // Call the delete function here
//     await webDeleteUserCartandItem(productIDString, strUserID, cartID);
//     print('Item Deleted Successfully: $productID');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Item Deleted Successfully From Cart'),
//       ),
//     );
//     // Don't fetch updated cart data here, we will do it in the FutureBuilder
//   } catch (e) {
//     print('Error deleting item: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to delete item from cart'),
//       ),
//     );
//   }
// }


  // double calculateTotalAmount() {
  //   // Calculate your total amount based on cartData here
  //   double totalAmount = 0;
  //   if (cartData != null) {
  //     for (var item in cartData!) {
  //       if (item['Qty'] > 0) {
  //         // Include the item's price in the total amount calculation
  //         totalAmount += (item['Qty'] * (item['ItemDiscountedPrice'] ?? 0));
  //       }
  //     }
  //   }
  //   return totalAmount;
  // }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  backgroundColor: Colors.white, // Set the background color to white
  title: Row(
    children: [
      Icon(Icons.shopping_cart, color: Colors.black), // Set the icon color to black
      SizedBox(width: 8.0),
      Text(
        'Your Cart',
        style: TextStyle(fontSize: 20.0, color: Colors.black), // Set the text color to black
      ),
    ],
  ),
),

    body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : cartData == null ||
                  cartData!.isEmpty ||
                  cartData?[0]['Result'] == 'Failed'
              ? Center(
                  child: Text('Your cart is empty.'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: cartData!.length,
                        itemBuilder: (context, index) {
                          final item = cartData![index];
                          if (item['Qty'] > 0) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                try {
                                  // Call the delete function here
                                  await webDeleteUserCartandItem(
                                    item['ProductID'],
                                    strUserID,
                                    item['CartID'].toString(),
                                  );
                                  didChangeDependencies();
                                  print('Item Deleted Successfully: ${item['ProductID']}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Item Deleted Successfully From Cart'),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error deleting item: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete item from cart'),
                                    ),
                                  );
                                }
                              },
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: item['ImagePath'] != null &&
                                              item['ImagePath'].isNotEmpty
                                          ? Image.network(
                                              item['ImagePath'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child: Text('Image not Found'),
                                            ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name:     ${item['BookName'] ?? 'No Book Name'}'),
                                          Text('Author:   ${item['AuthorName'] ?? 'No Author'}'),
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Price:    ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${item['SaleCurrency'] ?? 'No Currency'} ${item['Price'] ?? 'No Price'}',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' -${item['DiscountPer'] ?? 'No Discount'}%',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${item['SaleCurrency'] ?? 'No Currency'}${item['ItemDiscountedPrice'] ?? 'No Discounted Price'}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                            Text('Total:    INR ${item['TotalAmt'] ?? ''}'),
                                         //Text('Total:    ${item['SaleCurrency'] ?? 'No Currency'} ${item['TotalAmt'] ?? ''}'),
                                          // Text('Quantity: ${item['Qty'] ?? 'No Quantity'}'),
                                          Row(
  children: [
    IconButton(
  icon: const Icon(Icons.remove),
  onPressed: () {
    if (item['Qty'] > 1) {
      int updatedQty = item['Qty'] - 1;
      item['Qty'] = updatedQty; // Update the quantity immediately
      print('changed value: $updatedQty');
      
      webUpdateUserCart(
        item['ProductID'],
        strUserID,
        item['CartID'].toString(),
        updatedQty.toString(),
      ).then((result) {
        // Call _fetchUserCart after the update is complete
        _fetchUserCart();
      }).catchError((error) {
        // Handle errors here if needed
        print('Error updating cart: $error');
      });
    }
  },
),

    Text('  ${item['Qty']}  '),
   IconButton(
  icon: const Icon(Icons.add),
  onPressed: () {
    // if (item['Qty'] > 1) {
      int updatedQty = item['Qty'] + 1;
      item['Qty'] = updatedQty; // Update the quantity immediately
      print('changed value: $updatedQty');
      
      webUpdateUserCart(
        item['ProductID'],
        strUserID,
        item['CartID'].toString(),
        updatedQty.toString(),
      ).then((result) {
        // Call _fetchUserCart after the update is complete
        _fetchUserCart();
      }).catchError((error) {
        // Handle errors here if needed
        print('Error updating cart: $error');
      });
    // }
  },
),
  ],
),

                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // Add your deletion logic here
                                        try {
                                          await webDeleteUserCartandItem(
                                            item['ProductID'],
                                            strUserID,
                                            item['CartID'].toString(),
                                          );
                                          
                                  didChangeDependencies();
                                          print('Item Deleted Successfully: ${item['ProductID']}');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Item Deleted Successfully From Cart'),
                                            ),
                                          );
                                        } catch (e) {
                                          print('Error deleting item: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Failed to delete item from cart'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container(); // Return an empty container if Qty is 0
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                 Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      '    Order Summary:',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ),
  ],
),

            SizedBox(height: 15,),
                    Table(
  border: TableBorder.all(width: 0, color: Colors.transparent),
  children: [
    // Row 1
    TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '    Order Subtotal:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              //'${cartData?[0]['SaleCurrency']} ${NumberFormat('#,##0').format(cartData?[0]['BeforeShipCostNetAmt'])}    ',
              'INR ${NumberFormat('#,##0').format(cartData?[0]['BeforeShipCostNetAmt'])}    ',
               textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    ),

    // Row 2
    TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '    Shipping:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'INR ${cartData?[0]['ShipCost']}    ',
              // '${cartData?[0]['SaleCurrency']} ${cartData?[0]['ShipCost']}    ',
               textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    ),

    // Row 3
    TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '    Order Amount (Payable):',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'INR ${NumberFormat('#,##0').format(cartData?[0]['NetAmount'])}    ',
              // '${cartData?[0]['SaleCurrency']} ${NumberFormat('#,##0').format(cartData?[0]['NetAmount'])}    ',
                textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    ),

    // Button Row
    // TableRow(
    //   children: [
    //     TableCell(
    //       child: Container(), // Empty cell
    //     ),
    //     TableCell(
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: MaterialButton(
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => FormPage(
    //                   netAmount: cartData?[0]['NetAmount'] ?? 0.0,
    //                 ),
    //               ),
    //             );
    //           },
    //           color: Colors.blue,
    //           textColor: Colors.white,
    //           child: Text('Proceed to Fill Information'),
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
  ],
),
SizedBox(height: 15,),
Align(
  alignment: Alignment.centerRight,
  child: Padding(
    padding: EdgeInsets.only(right: 16.0), // Adjust the right padding as needed
    child: MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormPage(
              netAmount: cartData?[0]['NetAmount'] ?? 0.0,
            ),
          ),
        );
      },
      color: Colors.blue,
      textColor: Colors.white,
      child: Text('Proceed to Fill Information'),
    ),
  ),
),


            SizedBox(height: 15,),

                  ],
                ),
    );
  }
}