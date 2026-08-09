import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_shimmer.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
        ),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          // Include 'All' at the beginning just like the filter chips
          final allCategories = ['All', ...categories];

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              return InkWell(
                onTap: () {
                  // Set the global category filter and jump to Home tab
                  ref.read(selectedCategoryProvider.notifier).state = category;
                  context.go('/home');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getCategoryIcon(category),
                      const SizedBox(height: 16),
                      Text(
                        category.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const AppShimmer(width: double.infinity, height: double.infinity, borderRadius: 16),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    switch (category.toLowerCase()) {
      case 'electronics':
        iconData = Icons.computer;
        break;
      case 'jewelery':
        iconData = Icons.diamond_outlined;
        break;
      case 'men\'s clothing':
        iconData = Icons.checkroom;
        break;
      case 'women\'s clothing':
        iconData = Icons.dry_cleaning;
        break;
      case 'all':
      default:
        iconData = Icons.category_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 32, color: AppColors.primary),
    );
  }
}
