import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../../../core/network/dio_client.dart';

// Provides the repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioClientProvider); // We need to expose this globally or redefine.
  // Wait, dioClientProvider is currently in auth_provider.dart. 
  // It's better to move it to a shared location, but for now we can redefine it here or move it.
  return ProductRepositoryImpl(DioClient());
});

// Fetches all products
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Fetches all categories
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

// Holds the currently selected category filter ('All' by default)
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Filters products based on selected category
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsState = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsState.whenData((products) {
    if (selectedCategory == 'All') {
      return products;
    }
    return products.where((p) => p.category == selectedCategory).toList();
  });
});
