import 'package:flutter/material.dart';
import 'dart:convert';
class Cart {
  List<CartItem> items = [];

  void addToCart(Map<String, dynamic> productData, int quantity) {
    items.add(CartItem(productData: productData, quantity: quantity));
  }

  void removeFromCart(CartItem item) {
    items.remove(item);
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
