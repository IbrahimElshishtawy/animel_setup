// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../favorites/logic/favorites_cubit.dart';

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
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppMedia(
            imageUrl: imageUrl,
            heroTag: heroTag,
            fallbackImageUrl: AppMedia.animalPlaceholder,
          ),
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
            left: 12,
            top: 12,
            child: GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: BlocBuilder<FavoritesCubit, Set<String>>(
              builder: (context, favorites) {
                final isFavorite = favorites.contains(animal.id);

                return GestureDetector(
                  onTap: () => context.read<FavoritesCubit>().toggleAnimal(
                    animal.id,
                  ),
                  child: GlassPanel(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(999),
                    blurSigma: 12,
                    shadowOpacity: 0,
                    borderColor: Colors.white.withOpacity(0.24),
                    gradientColors: [
                      Colors.white.withOpacity(isDark ? 0.18 : 0.28),
                      Colors.white.withOpacity(isDark ? 0.12 : 0.18),
                    ],
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: isFavorite ? scheme.secondary : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
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
                    animal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
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
                              size: 13,
                              color: Colors.white.withOpacity(0.76),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                animal.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.82),
                                  fontSize: 11.5,
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
                        style: theme.textTheme.titleSmall?.copyWith(
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
          aspectRatio: 0.8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
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
