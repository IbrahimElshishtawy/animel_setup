import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../adoption/logic/adoption_bloc.dart';
import '../../home/data/home_content.dart';
import '../../home/logic/animal_bloc.dart';
import '../../home/widgets/animal_card.dart';
import '../logic/favorites_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: BlocBuilder<FavoritesCubit, Set<String>>(
          builder: (context, favorites) {
            return BlocBuilder<AnimalBloc, AnimalState>(
              builder: (context, animalState) {
                return BlocBuilder<AdoptionBloc, AdoptionState>(
                  builder: (context, adoptionState) {
                    final animals = _resolveFavorites(
                      favorites,
                      animalState.animals,
                      adoptionState.animals,
                    );

                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: AppSpacing.screenPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Favorites',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'All saved animals in one place for quick return later.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    gradient: LinearGradient(
                                      colors: [
                                        scheme.primary,
                                        Color.alphaBlend(
                                          scheme.secondary.withValues(
                                            alpha: 0.22,
                                          ),
                                          scheme.primary,
                                        ),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: AppShadows.soft(
                                      scheme.primary,
                                      opacity: 0.14,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Saved pets',
                                              style: theme.textTheme.labelLarge
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${animals.length} items',
                                              style: theme
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.14,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (animals.isEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
                              child: EmptyStateWidget(
                                title: 'No favorites yet',
                                message:
                                    'Tap the heart on any animal card and it will appear here.',
                                icon: Icons.favorite_border_rounded,
                              ),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: 0.8,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final animal = animals[index];
                                return AnimalCard(
                                  animal: animal,
                                  heroTag: 'favorite-${animal.id}',
                                  onTap: () => context.push(
                                    animal.isForAdoption
                                        ? '/adoption-details'
                                        : '/animal-details',
                                    extra: animal,
                                  ),
                                );
                              }, childCount: animals.length),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Animal> _resolveFavorites(
    Set<String> favoriteIds,
    List<Animal> animals,
    List<Animal> adoptionAnimals,
  ) {
    final catalog = <Animal>[
      ...animals,
      ...adoptionAnimals,
      ...HomeContent.featuredAnimals,
      ...HomeContent.adoptionSpotlights,
    ];
    final byId = <String, Animal>{};
    for (final animal in catalog) {
      byId[animal.id] = animal;
    }

    return favoriteIds
        .map((id) => byId[id])
        .whereType<Animal>()
        .toList(growable: false);
  }
}
