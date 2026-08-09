import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/products_provider.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filteredProductsAsync = ref.watch(filteredProductsProvider);

    final isSearchActive = ref.watch(isSearchActiveProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      drawer: const _HomeDrawer(),
      appBar: AppBar(
        title: isSearchActive
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: AppColors.textPrimary),
                cursorColor: AppColors.primary,
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 8),
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              )
            : Text(
                'Shewit',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              final activeNotifier = ref.read(isSearchActiveProvider.notifier);
              if (activeNotifier.state) {
                // If closing search, clear the query
                ref.read(searchQueryProvider.notifier).state = '';
              }
              activeNotifier.state = !activeNotifier.state;
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(productsProvider);
          ref.invalidate(categoriesProvider);
          // Wait for future to complete before hiding spinner
          try {
            await ref.read(productsProvider.future);
          } catch (_) {}
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even if not full
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
            
            // Featured Products Horizontal Slider (Only show when not searching)
            if (!isSearchActive)
              SliverToBoxAdapter(
                child: filteredProductsAsync.when(
                  data: (products) {
                    if (products.isEmpty) return const SizedBox.shrink();
                    
                    // Logic: Top 4 highest rated products
                    final featured = List.of(products)
                      ..sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
                    final topFeatured = featured.take(4).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Text('Featured', style: Theme.of(context).textTheme.titleLarge),
                        ),
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: topFeatured.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final product = topFeatured[index];
                              return SizedBox(
                                width: 160,
                                child: ShewitProductCard(
                                  product: product,
                                  onTap: () => context.push('/product/${product.id}'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),

            if (!isSearchActive)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text('All Products', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: filteredProductsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_outlined, size: 64, color: AppColors.borderSubtle),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isNotEmpty 
                                  ? "We couldn't find anything for '$searchQuery'"
                                  : "No products found.",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
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

class _HomeDrawer extends ConsumerWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to Shewit',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              context.go('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              context.go('/categories');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context);
              context.go('/cart');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: ref.watch(themeModeProvider),
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),
              onChanged: (ThemeMode? mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).state = mode;
                }
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
