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
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.background,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface, // required for shimmer to work
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
