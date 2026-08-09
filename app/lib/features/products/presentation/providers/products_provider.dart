import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Provides the repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioClientProvider); 
  return ProductRepositoryImpl(dio);
});

// Fetches all products
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Fetches a single product by ID for the details screen
final productDetailsProvider = FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});

// Fetches all categories
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

// Holds the currently selected category filter ('All' by default)
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Holds the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Controls the visibility of the search bar in the UI
final isSearchActiveProvider = StateProvider<bool>((ref) => false);

// Filters products based on selected category AND search query
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsState = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim().toLowerCase();

  return productsState.whenData((products) {
    var filtered = products;
    
    // Apply category filter
    if (selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }
    
    // Apply search filter (searches title and description)
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.title.toLowerCase().contains(searchQuery) ||
        p.description.toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    return filtered;
  });
});
