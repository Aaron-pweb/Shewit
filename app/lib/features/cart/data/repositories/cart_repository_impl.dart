import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final Box<String> _cartBox;
  
  static const String _cartKey = 'cart_items';

  CartRepositoryImpl(this._cartBox);

  @override
  Future<List<CartItem>> getCartItems() async {
    final cartJsonString = _cartBox.get(_cartKey);
    if (cartJsonString == null || cartJsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(cartJsonString);
      return jsonList.map((json) => CartItem.fromJson(json)).toList();
    } catch (e) {
      // If parsing fails, return empty cart
      return [];
    }
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    final List<Map<String, dynamic>> jsonList = 
        items.map((item) => item.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    
    await _cartBox.put(_cartKey, jsonString);
  }

  @override
  Future<void> clearCart() async {
    await _cartBox.delete(_cartKey);
  }
}
