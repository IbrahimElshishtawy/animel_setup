// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name : 'User';
    final profileImageUrl = authState is Authenticated
        ? authState.user.profileImageUrl
        : null;

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
                            subtitle:
                                'Find rare animals, adoption, and premium supplies',
                            profileImageUrl: profileImageUrl,
                            onProfileTap: () => context.go('/profile'),
                            onNotificationTap: () {},
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
                            items: HomeContent.banners,
                            onActionTap: (item) => context.push(item.route),
                          ),
                        ),
                        const SizedBox(height: 28),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 240),
                          child: const _HomeSectionHeader(
                            title: 'Browse by category',
                            subtitle:
                                'Curated paths for shopping, adoption, and discovery.',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInAnimation(
                          delay: const Duration(milliseconds: 300),
                          child: CategoriesList(
                            items: HomeContent.categories,
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
                            title: 'Food & Supplies',
                            subtitle:
                                'Modern essentials with premium presentation and quick actions.',
                            actionLabel: 'View shop',
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
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onTap != null)
          TextButton(onPressed: onTap, child: Text(actionLabel!)),
      ],
    );
  }
}

class _FeaturedAnimalsSection extends StatelessWidget {
  const _FeaturedAnimalsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        if (state.isLoading && state.animals.isEmpty) {
          return const _AnimalSectionSkeleton(
            title: 'Featured Animals',
            subtitle:
                'Trending listings from trusted sellers and standout breeders.',
          );
        }

        final animals = (state.animals.isNotEmpty
                ? state.animals
                : HomeContent.featuredAnimals)
            .take(6)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: 'Featured Animals',
              subtitle: state.errorMessage == null
                  ? 'Trending listings from trusted sellers and standout breeders.'
                  : 'Showing curated picks while live featured listings refresh.',
              actionLabel: 'See all',
              onTap: () => context.push('/animal-list'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 360,
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
            childAspectRatio: width >= 760 ? 0.78 : 0.67,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = HomeContent.products[index];

            return ProductCard(
              data: item,
              onTap: () => context.push('/product-details', extra: item.product),
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.product.name} added to cart')),
                );
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

  List<NearbyAnimalData> _buildNearbyItems(List<Animal> animals) {
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
        typeLabel: animal.isForAdoption ? 'Adoption' : 'Sale',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        final nearbyItems = _buildNearbyItems(state.animals);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: 'Nearby Animals',
              subtitle: 'Quick local discovery with a map-first preview.',
              actionLabel: 'Open map',
              onTap: () => context.push('/map'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 172,
              child: Row(
                children: [
                  Expanded(
                    flex: 11,
                    child: _MapPreviewCard(
                      onTap: () => context.push('/map'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 16,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: nearbyItems.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = nearbyItems[index];

                        return _NearbyAnimalCard(
                          data: item,
                          onTap: () => context.push(
                            '/animal-details',
                            extra: item.animal,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        if (state.isLoading && state.animals.isEmpty) {
          return const _AdoptionSectionSkeleton();
        }

        final animals = (state.animals.isNotEmpty
                ? state.animals
                : HomeContent.adoptionSpotlights)
            .take(3)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: 'Give Them a Home',
              subtitle: state.errorMessage == null
                  ? 'Warm, trustworthy adoption stories with quick actions.'
                  : 'Showing curated adoption spotlights while live adoption listings refresh.',
              actionLabel: 'See all',
              onTap: () => context.push('/adopt'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 332,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: animals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final animal = animals[index];

                  return _AdoptionSpotlightCard(
                    animal: animal,
                    onTap: () => context.push('/adoption-details', extra: animal),
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

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                scheme.primary.withOpacity(0.92),
                scheme.secondary.withOpacity(0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: AppShadows.soft(scheme.primary, opacity: 0.18),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 18,
                top: 22,
                right: 18,
                bottom: 22,
                child: Opacity(
                  opacity: 0.18,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white),
                    ),
                    child: CustomPaint(painter: _MapLinesPainter()),
                  ),
                ),
              ),
              const Positioned(
                left: 34,
                top: 42,
                child: _MapPinMarker(),
              ),
              const Positioned(
                right: 30,
                top: 62,
                child: _MapPinMarker(),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover nearby',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Open the map for local adoption and sale listings.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.84),
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

class _MapPinMarker extends StatelessWidget {
  const _MapPinMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppShadows.soft(Colors.black, opacity: 0.16),
      ),
      child: Icon(
        Icons.place_rounded,
        color: Theme.of(context).colorScheme.primary,
        size: 16,
      ),
    );
  }
}

class _MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final horizontalStep = size.height / 4;
    final verticalStep = size.width / 4;

    for (var i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, horizontalStep * i),
        Offset(size.width, horizontalStep * i),
        paint,
      );
      canvas.drawLine(
        Offset(verticalStep * i, 0),
        Offset(verticalStep * i, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NearbyAnimalCard extends StatelessWidget {
  const _NearbyAnimalCard({
    required this.data,
    required this.onTap,
  });

  final NearbyAnimalData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = data.animal.imageUrls.isEmpty
        ? null
        : data.animal.imageUrls.first;

    return SizedBox(
      width: 152,
      child: Material(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Image.asset(
                            'assets/image/image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              data.distance,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        data.typeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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

class _AdoptionSpotlightCard extends StatelessWidget {
  const _AdoptionSpotlightCard({
    required this.animal,
    required this.onTap,
  });

  final Animal animal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = animal.imageUrls.isEmpty ? null : animal.imageUrls.first;

    return SizedBox(
      width: 286,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFE3D0).withOpacity(
                theme.brightness == Brightness.dark ? 0.18 : 1,
              ),
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
                  top: Radius.circular(30),
                ),
                child: Image.network(
                  imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, _, _) => Image.asset(
                    'assets/image/image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Ready for adoption',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    animal.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${animal.breed} / ${animal.age}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    animal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: const Text('Adopt Now'),
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
  const _AnimalSectionSkeleton({
    required this.title,
    required this.subtitle,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HomeSectionHeader(
          title: 'Give Them a Home',
          subtitle: 'Warm, trustworthy adoption stories with quick actions.',
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
                      height: 168,
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    SizedBox(height: 18),
                    ShimmerBox(
                      height: 18,
                      width: 130,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 10),
                    ShimmerBox(
                      height: 14,
                      width: 180,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 12),
                    ShimmerBox(
                      height: 14,
                      width: 220,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    SizedBox(height: 16),
                    ShimmerBox(
                      height: 44,
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
