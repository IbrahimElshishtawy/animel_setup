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
        aspectRatio: 0.78,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppShadows.soft(
              scheme.primary,
              opacity: isDark ? 0.16 : 0.08,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppMedia(imageUrl: data.product.imageUrl),
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
                  left: 14,
                  top: 14,
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
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
                    child: Text(
                      data.accentLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
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
                          size: 14,
                          color: scheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: GlassPanel(
                    padding: const EdgeInsets.all(14),
                    borderRadius: BorderRadius.circular(24),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data.product.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.78),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _currency.format(data.product.price),
                                style: theme.textTheme.titleMedium?.copyWith(
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
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.16),
                                  ),
                                ),
                                child: Text(
                                  'Add',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
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
