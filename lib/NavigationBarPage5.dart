import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  List<CartItem> cartItems = [];

 @override
void initState() {
  super.initState();
  _loadCartData();
  // Check if productData and quantity are not null before adding to the cart
  if (widget.productData != null && widget.quantity != null) {
    addToCart(widget.productData!, widget.quantity!);
  }
}
 Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cart');
    if (cartData != null) {
      setState(() {
        cartItems = cartData
            .map((item) => CartItem.fromSharedPreferences(item))
            .toList();
      });
    }
  }

  // Function to save cart data to SharedPreferences
  Future<void> _saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = cartItems.map((item) => item.toSharedPreferences()).toList();
    await prefs.setStringList('cart', cartData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart),
              SizedBox(width: 8.0),
              Text(
                'Your Cart',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),

          // Conditionally display the message if cart is empty
          cartItems.isEmpty
              ? Center(
                  child: Text(
                    'Add items to cart',
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cartItems.map((item) {
                    return CartItemWidget(
                      itemName: item.productData['BookName'],
                      quantity: item.quantity,
                      price: item.productData['SalePrice'],
                      onRemove: () {
                        // Remove item from cart when "Remove" button is pressed
                        setState(() {
                          cartItems.remove(item);
                        });
                      },
                    );
                  }).toList(),
                ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showItemAddedPopup(); // Show pop-up when FAB is pressed
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

 void addToCart(Map<String, dynamic>? productData, int? quantity) {
    // Check if productData is null, and return early if it is
    if (productData == null || quantity == null) {
      return;
    }
    setState(() {
      cartItems.add(CartItem(productData: productData, quantity: quantity));
    });
    // Save the updated cart data
    _saveCartData();
  }
  // Function to show a pop-up message when an item is added
  void _showItemAddedPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Added Successfully'),
          content: Text('The item has been added to your cart.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
class CartItem {
  final Map<String, dynamic> productData;
  final int quantity;

  CartItem({required this.productData, required this.quantity});
   // Deserialize a CartItem from SharedPreferences
  factory CartItem.fromSharedPreferences(String item) {
    final parts = item.split(',');
    final productData = json.decode(parts[0]);
    final quantity = int.parse(parts[1]);
    return CartItem(productData: productData, quantity: quantity);}
     // Serialize a CartItem to a string for SharedPreferences
  String toSharedPreferences() {
    final productDataString = json.encode(productData);
    return '$productDataString,$quantity';
}}

class CartItemWidget extends StatelessWidget {
  final String itemName;
  final int quantity;
  final double price;
  final VoidCallback onRemove;

  CartItemWidget({
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemName),
      subtitle: Text('Quantity: $quantity'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Price: \$${price.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: onRemove,
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
