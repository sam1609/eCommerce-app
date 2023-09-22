import 'package:flutter/material.dart';
//import 'dart:async';
class NavigationBarPage5 extends StatefulWidget { 
  final String title;
  final String? display_Name;

  const NavigationBarPage5({super.key, required this.title, this.display_Name});

  @override
  _NavigationBarPage5State createState() => _NavigationBarPage5State();
}

class _NavigationBarPage5State extends State<NavigationBarPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 40.0), // Add padding at the top
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.shopping_cart), // Add the cart icon here
                SizedBox(width: 8.0), // Add some space between the icon and text
                Text(
                  'Your Cart',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
