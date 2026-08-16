import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0, // Matches default card radius
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2E) : AppColors.surfaceVariant,
      highlightColor: isDark ? const Color(0xFF3A3A3C) : AppColors.background,
      period: const Duration(milliseconds: 2000), // Smoother, slower premium feel
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : AppColors.surface, // required for shimmer to work
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
