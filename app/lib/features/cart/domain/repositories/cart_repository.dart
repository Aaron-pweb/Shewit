import '../../domain/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> saveCart(List<CartItem> items);
  Future<void> clearCart();
}
