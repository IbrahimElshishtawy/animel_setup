// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/glass_panel.dart';
import '../data/home_content.dart';

class ProductCard extends StatelessWidget {
  ProductCard({super.key, required this.data, this.onTap, this.onAddToCart});

  final HomeProductData data;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  final NumberFormat _currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return ScaleTap(
      onTap: onTap,
      scaleDown: 0.975,
      child: AspectRatio(
        aspectRatio: 0.82,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppShadows.soft(
              scheme.primary,
              opacity: isDark ? 0.16 : 0.08,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppMedia(
                  imageUrl: data.product.imageUrl,
                  fallbackImageUrl: AppMedia.productPlaceholder,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.02),
                        Colors.black.withOpacity(0.08),
                        Colors.black.withOpacity(0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    blurSigma: 12,
                    shadowOpacity: 0,
                    borderColor: Colors.white.withOpacity(0.22),
                    gradientColors: [
                      Colors.white.withOpacity(isDark ? 0.18 : 0.26),
                      Colors.white.withOpacity(isDark ? 0.12 : 0.18),
                    ],
                    child: Text(
                      data.accentLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    blurSigma: 12,
                    shadowOpacity: 0,
                    borderColor: Colors.white.withOpacity(0.22),
                    gradientColors: [
                      Colors.white.withOpacity(isDark ? 0.18 : 0.26),
                      Colors.white.withOpacity(isDark ? 0.12 : 0.18),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: scheme.secondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          data.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: GlassPanel(
                    padding: const EdgeInsets.all(12),
                    borderRadius: BorderRadius.circular(22),
                    blurSigma: 18,
                    borderColor: Colors.white.withOpacity(0.18),
                    gradientColors: [
                      Colors.white.withOpacity(isDark ? 0.14 : 0.24),
                      Colors.white.withOpacity(isDark ? 0.08 : 0.14),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data.product.category} • ${data.product.animalType}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _currency.format(data.product.price),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: scheme.secondary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            ScaleTap(
                              onTap: onAddToCart,
                              scaleDown: 0.92,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.16),
                                  ),
                                ),
                                child: Text(
                                  'Add',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
