import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../../products/data/models/product_model.dart';

// Must be overridden in main.dart after Hive.openBox
final cartBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('cartBoxProvider not initialized');
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final box = ref.watch(cartBoxProvider);
  return CartRepositoryImpl(box);
});

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<List<CartItem>>>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return CartNotifier(repo);
});

class CartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  final CartRepository _repo;
  Timer? _saveTimer;

  CartNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await _repo.getCartItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Debounces disk writes to save battery and I/O when spamming quantity buttons
  void _debouncedSave(List<CartItem> items) {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), () async {
      await _repo.saveCart(items);
    });
  }

  Future<void> addToCart(Product product, int quantity) async {
    if (state is! AsyncData) return;
    
    final currentList = state.value!;
    final index = currentList.indexWhere((item) => item.product.id == product.id);
    
    List<CartItem> newList;
    if (index >= 0) {
      newList = List.from(currentList);
      final existingItem = newList[index];
      int newQuantity = existingItem.quantity + quantity;
      if (newQuantity > 99) newQuantity = 99; // Soft Limit
      newList[index] = existingItem.copyWith(quantity: newQuantity);
    } else {
      int newQuantity = quantity > 99 ? 99 : quantity; // Soft Limit
      newList = [...currentList, CartItem(product: product, quantity: newQuantity)];
    }
    
    state = AsyncValue.data(newList);
    _debouncedSave(newList); // Optimistic UI, debounced disk write
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (state is! AsyncData) return;
    
    final currentList = state.value!;
    final index = currentList.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      final newList = List<CartItem>.from(currentList);
      if (quantity > 0) {
        int safeQuantity = quantity > 99 ? 99 : quantity; // Soft Limit
        newList[index] = newList[index].copyWith(quantity: safeQuantity);
      } else {
        newList.removeAt(index);
      }
      state = AsyncValue.data(newList);
      _debouncedSave(newList); // Optimistic UI, debounced disk write
    }
  }

  Future<void> removeFromCart(int productId) async {
    await updateQuantity(productId, 0);
  }

  Future<void> clearCart() async {
    state = const AsyncValue.data([]);
    _saveTimer?.cancel(); 
    await _repo.clearCart(); // Empty cart saves immediately
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }
}

// Calculates total number of items for the navigation badge
final cartItemCountProvider = Provider<int>((ref) {
  final state = ref.watch(cartProvider);
  return state.maybeWhen(
    data: (items) => items.fold(0, (sum, item) => sum + item.quantity),
    orElse: () => 0,
  );
});

// Calculates the financial subtotal for the checkout view
final cartSubtotalProvider = Provider<double>((ref) {
  final state = ref.watch(cartProvider);
  return state.maybeWhen(
    data: (items) => items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity)),
    orElse: () => 0.0,
  );
});
