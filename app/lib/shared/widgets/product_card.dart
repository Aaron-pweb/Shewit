import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/data/models/product_model.dart';
import 'app_shimmer.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/profile/presentation/providers/wishlist_provider.dart';

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
    return _ScaleOnPress(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
                    color: Theme.of(context).cardColor, // Adapts to light/dark
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Theme.of(context).brightness == Brightness.dark
                        ? ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFB0B0B0), // Dims the harsh white JPEG backgrounds
                              BlendMode.multiply,
                            ),
                              child: Hero(
                                tag: 'product_image_${product.id}',
                                child: CachedNetworkImage(
                                  imageUrl: product.image,
                                  fit: BoxFit.contain,
                                  memCacheWidth: 400,
                                  placeholder: (context, url) => const AppShimmer(
                                    width: double.infinity,
                                    height: double.infinity,
                                    borderRadius: 0,
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.broken_image_outlined, color: Theme.of(context).dividerColor, size: 48),
                                  ),
                                ),
                              ),
                            )
                          : Hero(
                              tag: 'product_image_${product.id}',
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                fit: BoxFit.contain,
                                memCacheWidth: 400,
                                placeholder: (context, url) => const AppShimmer(
                                  width: double.infinity,
                                  height: double.infinity,
                                  borderRadius: 0,
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(Icons.broken_image_outlined, color: Theme.of(context).dividerColor, size: 48),
                                ),
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
                        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Theme.of(context).colorScheme.secondary, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.rate.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: _FavoriteButton(product: product),
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
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(cartProvider.notifier).addToCart(product, 1);
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
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final Product product;
  const _FavoriteButton({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wishlistProvider);
    final isFavorite = ref.read(wishlistProvider.notifier).isFavorite(product.id);

    return IconButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        ref.read(wishlistProvider.notifier).toggleFavorite(product);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFavorite ? 'Removed from Wishlist' : 'Added to Wishlist'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
        size: 20,
      ),
      splashRadius: 20,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

class _ScaleOnPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleOnPress({required this.child, required this.onTap});

  @override
  State<_ScaleOnPress> createState() => _ScaleOnPressState();
}

class _ScaleOnPressState extends State<_ScaleOnPress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
