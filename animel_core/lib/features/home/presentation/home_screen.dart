// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/fade_in_animation.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../adoption/logic/adoption_bloc.dart';
import '../../auth/logic/auth_bloc.dart';
import '../data/home_content.dart';
import '../logic/animal_bloc.dart';
import '../widgets/animal_card.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/categories_list.dart';
import '../widgets/home_header.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _prefetchData();
  }

  void _prefetchData() {
    final animalBloc = context.read<AnimalBloc>();
    final adoptionBloc = context.read<AdoptionBloc>();

    if (animalBloc.state.animals.isEmpty && !animalBloc.state.isLoading) {
      animalBloc.add(const FetchAnimals());
    }
    if (adoptionBloc.state.animals.isEmpty && !adoptionBloc.state.isLoading) {
      adoptionBloc.add(const FetchAdoptionAnimals());
    }
  }

  List<HomeBannerData> _localizedBanners(AppCopy copy) {
    return [
      HomeBannerData(
        title: copy.bannerTrustedCompanionsTitle,
        subtitle: copy.bannerTrustedCompanionsSubtitle,
        ctaLabel: copy.bannerTrustedCompanionsCta,
        route: HomeContent.banners[0].route,
        imageUrl: HomeContent.banners[0].imageUrl,
        gradientColors: HomeContent.banners[0].gradientColors,
      ),
      HomeBannerData(
        title: copy.bannerUrgentAdoptionTitle,
        subtitle: copy.bannerUrgentAdoptionSubtitle,
        ctaLabel: copy.bannerUrgentAdoptionCta,
        route: HomeContent.banners[1].route,
        imageUrl: HomeContent.banners[1].imageUrl,
        gradientColors: HomeContent.banners[1].gradientColors,
      ),
      HomeBannerData(
        title: copy.bannerHelpersTitle,
        subtitle: copy.bannerHelpersSubtitle,
        ctaLabel: copy.bannerHelpersCta,
        route: HomeContent.banners[2].route,
        imageUrl: HomeContent.banners[2].imageUrl,
        gradientColors: HomeContent.banners[2].gradientColors,
      ),
    ];
  }

  List<HomeCategoryData> _localizedCategories(AppCopy copy) {
    return [
      HomeCategoryData(
        label: copy.petsCategory,
        icon: HomeContent.categories[0].icon,
        tint: HomeContent.categories[0].tint,
        route: HomeContent.categories[0].route,
      ),
      HomeCategoryData(
        label: copy.adoptionCategory,
        icon: HomeContent.categories[1].icon,
        tint: HomeContent.categories[1].tint,
        route: HomeContent.categories[1].route,
      ),
      HomeCategoryData(
        label: copy.foodCategory,
        icon: HomeContent.categories[2].icon,
        tint: HomeContent.categories[2].tint,
        route: HomeContent.categories[2].route,
      ),
      HomeCategoryData(
        label: copy.accessoriesCategory,
        icon: HomeContent.categories[3].icon,
        tint: HomeContent.categories[3].tint,
        route: HomeContent.categories[3].route,
      ),
      HomeCategoryData(
        label: copy.servicesCategory,
        icon: HomeContent.categories[4].icon,
        tint: HomeContent.categories[4].tint,
        route: HomeContent.categories[4].route,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final theme = Theme.of(context);
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name : '';
    final profileImageUrl = authState is Authenticated
        ? authState.user.profileImageUrl
        : null;
    final banners = _localizedBanners(copy);
    final categories = _localizedCategories(copy);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: Stack(
        children: [
          const _DecorativeBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 60),
                          child: HomeHeader(
                            userName: userName,
                            subtitle: copy.homeHeroSubtitle,
                            profileImageUrl: profileImageUrl,
                            onProfileTap: () => context.go('/profile'),
                            onNotificationTap: () =>
                                context.push('/notifications'),
                            currentLocation: authState is Authenticated
                                ? (authState.user.location ?? copy.nearby)
                                : copy.nearby,
                            onLocationTap: () => context.push('/map'),
                          ),
                        ),
                        const SizedBox(height: 22),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 120),
                          child: SearchBarWidget(
                            onTap: () => context.push('/search'),
                            onFilterTap: () => context.push('/search'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 180),
                          child: BannerCarousel(
                            items: banners,
                            onActionTap: (item) => context.push(item.route),
                          ),
                        ),
                        const SizedBox(height: 28),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 240),
                          child: _HomeSectionHeader(
                            title: copy.browseCategory,
                            subtitle: copy.browseCategorySubtitle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 300),
                          child: CategoriesList(
                            items: categories,
                            onSelected: (item) => context.push(item.route),
                          ),
                        ),
                        const SizedBox(height: 34),
                        const FadeInAnimation(
                          delay: Duration(milliseconds: 360),
                          child: _FeaturedAnimalsSection(),
                        ),
                        const SizedBox(height: 34),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 420),
                          child: _HomeSectionHeader(
                            title: copy.foodAndSupplies,
                            subtitle: copy.foodAndSuppliesSubtitle,
                            actionLabel: copy.viewShop,
                            onTap: () => context.push('/shop'),
                          ),
                        ),
                        const SizedBox(height: 18),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 480),
                          child: const _ProductsSection(),
                        ),
                        const SizedBox(height: 34),
                        const FadeInAnimation(
                          delay: Duration(milliseconds: 540),
                          child: _NearbyAnimalsSection(),
                        ),
                        const SizedBox(height: 34),
                        const FadeInAnimation(
                          delay: Duration(milliseconds: 600),
                          child: _AdoptionSpotlightSection(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE8B365).withOpacity(isDark ? 0.18 : 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B2E6F).withOpacity(isDark ? 0.16 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              actionLabel!,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedAnimalsSection extends StatelessWidget {
  const _FeaturedAnimalsSection();

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        if (state.isLoading && state.animals.isEmpty) {
          return _AnimalSectionSkeleton(
            title: copy.featuredAnimals,
            subtitle: copy.featuredAnimalsSubtitle,
          );
        }

        final animals =
            (state.animals.isNotEmpty
                    ? state.animals
                    : HomeContent.featuredAnimals)
                .take(6)
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: copy.featuredAnimals,
              subtitle: state.errorMessage == null
                  ? copy.featuredAnimalsSubtitle
                  : copy.featuredAnimalsRefreshing,
              actionLabel: copy.seeAll,
              onTap: () => context.push('/animal-list'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 328,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: animals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final animal = animals[index];
                  return AnimalCard(
                    animal: animal,
                    heroTag: 'animal-${animal.id}',
                    onTap: () => context.push('/animal-details', extra: animal),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection();

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1024
            ? 4
            : width >= 760
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: HomeContent.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: width >= 760 ? 0.86 : 0.74,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final item = HomeContent.products[index];

            return ProductCard(
              data: item,
              onTap: () =>
                  context.push('/product-details', extra: item.product),
              onAddToCart: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(copy.addedToCart)));
              },
            );
          },
        );
      },
    );
  }
}

class _NearbyAnimalsSection extends StatelessWidget {
  const _NearbyAnimalsSection();

  List<NearbyAnimalData> _buildNearbyItems(List<Animal> animals, AppCopy copy) {
    if (animals.isEmpty) {
      return HomeContent.nearbyAnimals;
    }

    final distances = ['0.9 km', '1.8 km', '3.1 km'];

    return animals.take(3).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final animal = entry.value;

      return NearbyAnimalData(
        animal: animal,
        distance: distances[index % distances.length],
        typeLabel: animal.isForAdoption ? copy.adoptionLabel : copy.forSale,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        final nearbyItems = _buildNearbyItems(state.animals, copy);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: copy.nearbyAnimalsTitle,
              subtitle: copy.nearbyAnimalsSubtitle,
              actionLabel: copy.openMap,
              onTap: () => context.push('/map'),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearbyItems.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = nearbyItems[index];

                return SizedBox(
                  height: 118,
                  child: _NearbyAnimalCard(
                    data: item,
                    onTap: () =>
                        context.push('/animal-details', extra: item.animal),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _AdoptionSpotlightSection extends StatelessWidget {
  const _AdoptionSpotlightSection();

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        if (state.isLoading && state.animals.isEmpty) {
          return const _AdoptionSectionSkeleton();
        }

        final animals =
            (state.animals.isNotEmpty
                    ? state.animals
                    : HomeContent.adoptionSpotlights)
                .take(3)
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: copy.adoptionSpotlightTitle,
              subtitle: state.errorMessage == null
                  ? copy.adoptionSpotlightSubtitle
                  : copy.adoptionRefreshing,
              actionLabel: copy.seeAll,
              onTap: () => context.push('/adopt'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: animals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final animal = animals[index];

                  return _AdoptionSpotlightCard(
                    animal: animal,
                    onTap: () =>
                        context.push('/adoption-details', extra: animal),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NearbyAnimalCard extends StatelessWidget {
  const _NearbyAnimalCard({required this.data, required this.onTap});

  final NearbyAnimalData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = data.animal.imageUrls.isEmpty
        ? null
        : data.animal.imageUrls.first;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: scheme.outlineVariant.withOpacity(0.78)),
            boxShadow: AppShadows.soft(Colors.black, opacity: 0.04),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(24),
                ),
                child: SizedBox(
                  width: 104,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppMedia(
                        imageUrl: imageUrl,
                        fallbackImageUrl: AppMedia.animalPlaceholder,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.02),
                              Colors.transparent,
                              Colors.black.withOpacity(0.28),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              data.distance,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            data.typeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.animal.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.animal.breed} • ${data.animal.location}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.animal.isForAdoption
                            ? 'Adopt'
                            : '\$${data.animal.price.toStringAsFixed(0)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdoptionSpotlightCard extends StatelessWidget {
  const _AdoptionSpotlightCard({required this.animal, required this.onTap});

  final Animal animal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = animal.imageUrls.isEmpty ? null : animal.imageUrls.first;

    return SizedBox(
      width: 256,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              const Color(
                0xFFFFE3D0,
              ).withOpacity(theme.brightness == Brightness.dark ? 0.18 : 1),
              theme.cardColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.78)),
          boxShadow: AppShadows.soft(const Color(0xFFDB9A6F), opacity: 0.12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: AppMedia(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fallbackImageUrl: AppMedia.animalPlaceholder,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      copy.readyForAdoption,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.secondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    animal.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${animal.breed} / ${animal.age}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    animal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: Text(
                        copy.adoptNow,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalSectionSkeleton extends StatelessWidget {
  const _AnimalSectionSkeleton({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 18),
        SizedBox(
          height: 360,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 252,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: const [
                    ShimmerBox(
                      height: 210,
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    SizedBox(height: 16),
                    ShimmerBox(
                      height: 18,
                      width: 120,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 10),
                    ShimmerBox(
                      height: 14,
                      width: 160,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 16),
                    ShimmerBox(
                      height: 16,
                      width: 90,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AdoptionSectionSkeleton extends StatelessWidget {
  const _AdoptionSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(
          title: copy.adoptionSpotlightTitle,
          subtitle: copy.adoptionSpotlightSubtitle,
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 332,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 286,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: const [
                    ShimmerBox(
                      height: 152,
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    SizedBox(height: 16),
                    ShimmerBox(
                      height: 18,
                      width: 130,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 8),
                    ShimmerBox(
                      height: 14,
                      width: 180,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 10),
                    ShimmerBox(
                      height: 14,
                      width: 220,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 14),
                    ShimmerBox(
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
