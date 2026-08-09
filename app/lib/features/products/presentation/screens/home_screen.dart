import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_provider.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filteredProductsAsync = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shewit',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Phase 8 Search
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Categories Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: categoriesAsync.when(
                data: (categories) => _CategoryList(categories: ['All', ...categories]),
                loading: () => const _CategoryListSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),
          
          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: filteredProductsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No products found.')),
                  );
                }
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65, // Adjust based on card design
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ShewitProductCard(
                        product: product,
                        onTap: () {
                          context.push('/product/${product.id}');
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                );
              },
              loading: () => SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const AppShimmer(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 8,
                  ),
                  childCount: 6, // Show 6 skeletons
                ),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                      const SizedBox(height: 16),
                      Text('Failed to load products.', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(productsProvider);
                          ref.invalidate(categoriesProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  final List<String> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selected;
          return ActionChip(
            label: Text(
              cat.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                  ),
            ),
            backgroundColor: isSelected ? AppColors.textPrimary : Colors.transparent,
            side: BorderSide(
              color: isSelected ? AppColors.textPrimary : AppColors.borderSubtle,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), // Pill shaped
            onPressed: () {
              ref.read(selectedCategoryProvider.notifier).state = cat;
            },
          );
        },
      ),
    );
  }
}

class _CategoryListSkeleton extends StatelessWidget {
  const _CategoryListSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, __) => const AppShimmer(width: 100, height: 40, borderRadius: 100),
      ),
    );
  }
}
