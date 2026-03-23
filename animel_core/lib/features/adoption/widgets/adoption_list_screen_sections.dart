// ignore_for_file: deprecated_member_use

part of '../presentation/adoption_list_screen.dart';

class AdoptionListHeroSection extends StatelessWidget {
  const AdoptionListHeroSection({super.key, required this.animalsCount});

  final int animalsCount;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          copy.adoptAFriend,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          copy.adoptFriendSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              colors: [
                AppPalette.magenta,
                Color.alphaBlend(
                  scheme.secondary.withOpacity(0.26),
                  AppPalette.magenta,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: AppShadows.soft(AppPalette.magenta, opacity: 0.18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy.adoptionReady,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      copy.companionsWaiting(animalsCount),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      copy.adoptionExploreHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.82),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdoptionListCard extends StatelessWidget {
  const AdoptionListCard({super.key, required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = animal.imageUrls.isEmpty ? null : animal.imageUrls.first;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/adoption-details', extra: animal),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: AppShadows.soft(Colors.black, opacity: 0.05),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  width: 116,
                  height: 116,
                  child: AppMedia(
                    imageUrl: imageUrl,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.magenta.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          copy.adoptionLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppPalette.magenta,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        animal.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${animal.breed} - ${animal.age}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety_outlined,
                            size: 16,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              animal.healthStatus,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 16,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              animal.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    BlocBuilder<FavoritesCubit, Set<String>>(
                      builder: (context, favorites) {
                        final isFavorite = favorites.contains(animal.id);
                        return IconButton(
                          onPressed: () => context
                              .read<FavoritesCubit>()
                              .toggleAnimal(animal.id),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: isFavorite
                                ? scheme.secondary
                                : scheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
