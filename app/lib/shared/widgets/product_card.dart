import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/data/models/product_model.dart';
import '../../core/theme/app_colors.dart';
import 'app_shimmer.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class ShewitProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;

  const ShewitProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section with 4:5 ratio feel
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.white, // Pure white background for product photos
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                        memCacheWidth: 400, // Optimize memory for lists
                        placeholder: (context, url) => const AppShimmer(
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: 0,
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_outlined, color: AppColors.borderSubtle, size: 48),
                        ),
                      ),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: AppColors.secondary, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.rate.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        product.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _AddButton(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends ConsumerWidget {
  final Product product;
  const _AddButton({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We will hook this up to the real cart in Phase 9.
    // For now it acts as a visual mockup.
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${product.title} to cart'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}
