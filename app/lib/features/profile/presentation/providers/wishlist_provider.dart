import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../products/data/models/product_model.dart';

final wishlistBoxProvider = Provider<Box<String>>((ref) => throw UnimplementedError());

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  final box = ref.watch(wishlistBoxProvider);
  return WishlistNotifier(box);
});

class WishlistNotifier extends StateNotifier<List<Product>> {
  final Box<String> _box;
  static const String _key = 'wishlist_items';

  WishlistNotifier(this._box) : super([]) {
    _loadWishlist();
  }

  void _loadWishlist() {
    try {
      final data = _box.get(_key);
      if (data != null && data.isNotEmpty) {
        final List<dynamic> decoded = json.decode(data);
        state = decoded.map((e) => Product.fromJson(e)).toList();
      }
    } catch (e) {
      state = [];
    }
  }

  void _saveWishlist() {
    final encoded = json.encode(state.map((p) => p.toJson()).toList());
    _box.put(_key, encoded);
  }

  bool isFavorite(int productId) {
    return state.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    _saveWishlist();
  }

  void clearWishlist() {
    state = [];
    _saveWishlist();
  }
}
