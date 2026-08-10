import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_provider.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(categoryName.toUpperCase()),
      ),
      body: productsAsync.when(
        data: (products) {
          final categoryProducts = categoryName.toLowerCase() == 'all'
              ? products
              : products.where((p) => p.category.toLowerCase() == categoryName.toLowerCase()).toList();

          if (categoryProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category_outlined, size: 64, color: AppColors.borderSubtle),
                  const SizedBox(height: 16),
                  Text('No products found in this category.', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  '${categoryProducts.length} items',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts[index];
                    return ShewitProductCard(
                      product: product,
                      onTap: () => context.push('/product/${product.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const AppShimmer(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 8,
          ),
        ),
        error: (err, stack) => Center(child: Text('Error loading products: $err')),
      ),
    );
  }
}
