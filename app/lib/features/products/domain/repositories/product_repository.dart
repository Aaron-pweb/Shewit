import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
}
