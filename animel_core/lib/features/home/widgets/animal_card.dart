// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/glass_panel.dart';

class AnimalCard extends StatelessWidget {
  AnimalCard({
    super.key,
    required this.animal,
    this.onTap,
    this.heroTag,
    this.width,
  });

  final Animal animal;
  final VoidCallback? onTap;
  final String? heroTag;
  final double? width;

  final NumberFormat _currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  String get _badgeLabel {
    if (animal.isForAdoption) {
      return 'Adopt';
    }
    if (animal.price >= 1000) {
      return 'Premium';
    }
    return 'Listing';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final imageUrl = animal.imageUrls.isEmpty ? null : animal.imageUrls.first;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppMedia(imageUrl: imageUrl, heroTag: heroTag),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.08),
                  Colors.black.withOpacity(0.38),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: 14,
            right: 14,
            child: Row(
              children: [
                GlassPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  blurSigma: 12,
                  shadowOpacity: 0,
                  borderColor: Colors.white.withOpacity(0.24),
                  gradientColors: [
                    Colors.white.withOpacity(isDark ? 0.18 : 0.28),
                    Colors.white.withOpacity(isDark ? 0.12 : 0.18),
                  ],
                  child: Text(
                    _badgeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                GlassPanel(
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(16),
                  blurSigma: 12,
                  shadowOpacity: 0,
                  borderColor: Colors.white.withOpacity(0.24),
                  gradientColors: [
                    Colors.white.withOpacity(isDark ? 0.18 : 0.28),
                    Colors.white.withOpacity(isDark ? 0.12 : 0.18),
                  ],
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
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
                    animal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    animal.breed,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.82),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.place_rounded,
                              size: 15,
                              color: Colors.white.withOpacity(0.76),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                animal.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.82),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        animal.isForAdoption
                            ? 'Adopt'
                            : _currency.format(animal.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w800,
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
    );

    return SizedBox(
      width: width,
      child: ScaleTap(
        onTap: onTap,
        scaleDown: 0.975,
        child: AspectRatio(
          aspectRatio: 0.76,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: AppShadows.soft(
                scheme.primary,
                opacity: isDark ? 0.18 : 0.1,
              ),
            ),
            child: card,
          ),
        ),
      ),
    );
  }
}
