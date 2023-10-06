import 'package:flutter/material.dart';
import 'API.dart'; // Import the file containing webGetUserCart function
import 'dart:async'; // Import to work with Futures
import 'package:flutter/widgets.dart'; // Import to use Image widget

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

  @override
  void initState() {
    super.initState();
    _fetchUserCart();
  }

  Future<void> _fetchUserCart() async {
    try {
      final cart = await webGetUserCart(); // Call the API function
      setState(() {
        cartData = cart;
      });
    } catch (e) {
      // Handle the error here (e.g., show an error message)
      print('Error fetching cart data: $e');
    }
  }

  double calculateTotalAmount() {
    // Calculate your total amount based on cartData here
    double totalAmount = 0;
    if (cartData != null) {
      for (var item in cartData!) {
        if (item['Qty'] > 0) {
          // Include the item's price in the total amount calculation
          totalAmount += (item['Qty'] * (item['ItemDiscountedPrice'] ?? 0));
        }
      }
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_cart),
              SizedBox(width: 8.0),
              Text(
                'Your Cart',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          if (cartData != null)
  for (var item in cartData!)
    if (item['Qty'] > 0)
      Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          try {
            // Call the delete function here
            await webDeleteUserCartandItem(
              item['ProductID'],
              'WEB_139',
              item['CartID'].toString(),
            );
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
                child: 
                Container(
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
                            Text(item['BookName'] ?? 'No Book Name'),
                            Text('Author: ${item['AuthorName'] ?? 'No Author'}'),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Price: ',
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
                            Text('Quantity: ${item['Qty'] ?? 'No Quantity'}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
              else
                Container(), // Return an empty container if Qty is 0
          Container(
            margin: EdgeInsets.only(top: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text('${cartData?[1]['BeforeShipCostNetAmt']}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '+${cartData?[1]['ShipCost']}(Shipping)', // Replace with the actual ship cost
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                Row( crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Text(
                  'NetAmount: ${cartData?[1]['NetAmount']}', // Replace with the actual net amount
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                 Text(
                  ' (payable)', 
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
