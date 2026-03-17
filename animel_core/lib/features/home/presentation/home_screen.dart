// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../logic/animal_bloc.dart';
import '../widgets/address_field.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimalBloc>().add(FetchAnimals());
    });
  }

  Future<void> _refresh() async {
    context.read<AnimalBloc>().add(FetchAnimals());
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F7),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7F3), Color(0xFFF8F3F7), Color(0xFFF3EAF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<AnimalBloc, AnimalState>(
            builder: (context, state) {
              final animals =
                  state is AnimalLoaded ? state.animals : const <Animal>[];

              return RefreshIndicator(
                color: const Color(0xFF4B1A45),
                onRefresh: _refresh,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          HomeHeader(onProfileTap: () => context.go('/profile')),
                          const SizedBox(height: 16),
                          const AddressField(),
                          const SizedBox(height: 18),
                          _HomeHeroCard(
                            onReportTap: () => context.go('/report'),
                            onMapTap: () => context.go('/map'),
                          ),
                          const SizedBox(height: 22),
                          const _SectionHeader(
                            title: 'Quick Actions',
                            subtitle: 'Everything important in one calm view.',
                          ),
                          const SizedBox(height: 14),
                          _QuickActionsGrid(
                            onTap: (route) => context.go(route),
                          ),
                          const SizedBox(height: 22),
                          const _SectionHeader(
                            title: 'Browse by Animal Type',
                            subtitle:
                                'Start from the kind of animal you are looking for.',
                          ),
                          const SizedBox(height: 14),
                          _AnimalTypesScroller(
                            onExplore: () => context.go('/search'),
                          ),
                          const SizedBox(height: 22),
                          const _SectionHeader(
                            title: 'Find by Goal',
                            subtitle:
                                'Adoption, buying, or breeding support in one place.',
                          ),
                          const SizedBox(height: 14),
                          _GoalCardsRow(
                            onAdoptTap: () => context.go('/adopt'),
                            onBuyTap: () => context.go('/animal-list'),
                            onBreedTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Breeding section can be added next.',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 22),
                          const _SectionHeader(
                            title: 'Community Pulse',
                            subtitle:
                                'A softer snapshot of what matters today.',
                          ),
                          const SizedBox(height: 14),
                          _PulseRow(animals: animals),
                          const SizedBox(height: 22),
                          _SectionHeader(
                            title: 'Recently Added',
                            subtitle:
                                'Fresh profiles and new opportunities to help.',
                            actionLabel: 'See all',
                            onActionTap: () => context.push('/animal-list'),
                          ),
                          const SizedBox(height: 14),
                        ]),
                      ),
                    ),
                    _RecentAnimalsSliver(state: state, onRetry: _refresh),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
                        child: _CareIdeaCard(
                          onDonateTap: () => context.go('/donation'),
                          onAdoptTap: () => context.go('/adopt'),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard({
    required this.onReportTap,
    required this.onMapTap,
  });

  final VoidCallback onReportTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF4B1A45), Color(0xFF8A3C67)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4B1A45),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Nearby rescue activity',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.pets_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'A cleaner home for finding, reporting, and helping animals faster.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Track nearby cases, open the map quickly, and jump into the actions that matter most.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(child: _HeroMetric(value: '12+', label: 'Active updates')),
              SizedBox(width: 10),
              Expanded(child: _HeroMetric(value: '4', label: 'Quick paths')),
              SizedBox(width: 10),
              Expanded(
                child: _HeroMetric(value: '24/7', label: 'Community care'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroActionButton(
                  label: 'Report case',
                  isPrimary: true,
                  onTap: onReportTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroActionButton(
                  label: 'Open map',
                  isPrimary: false,
                  onTap: onMapTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(18),
            border: isPrimary
                ? null
                : Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPrimary ? Icons.campaign_rounded : Icons.map_rounded,
                size: 18,
                color: isPrimary ? const Color(0xFF4B1A45) : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? const Color(0xFF4B1A45) : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2F1B2D),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF8B7B88),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: Color(0xFF4B1A45),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickActionItem(
        title: 'Report Rescue',
        subtitle: 'Open a new lost or found case.',
        icon: Icons.campaign_rounded,
        colors: [Color(0xFF4B1A45), Color(0xFF7C355D)],
        route: '/report',
      ),
      _QuickActionItem(
        title: 'Browse Pets',
        subtitle: 'See available animal profiles nearby.',
        icon: Icons.pets_rounded,
        colors: [Color(0xFFE27D60), Color(0xFFF09A7E)],
        route: '/animal-list',
      ),
      _QuickActionItem(
        title: 'Adoption Hub',
        subtitle: 'Find adoption-ready companions.',
        icon: Icons.favorite_rounded,
        colors: [Color(0xFFBC567E), Color(0xFFD582A1)],
        route: '/adopt',
      ),
      _QuickActionItem(
        title: 'Pet Supplies',
        subtitle: 'Food, care, and everyday essentials.',
        icon: Icons.shopping_bag_rounded,
        colors: [Color(0xFF4B8FA5), Color(0xFF72B4C6)],
        route: '/shop',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.98,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(item.route),
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: item.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.colors.first.withOpacity(0.18),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(item.icon, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),
                      height: 1.4,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final String route;
}

class _PulseRow extends StatelessWidget {
  const _PulseRow({required this.animals});

  final List<Animal> animals;

  @override
  Widget build(BuildContext context) {
    final listedCount = animals.isEmpty ? 4 : animals.length;
    final vaccinatedCount = animals
        .where((animal) => animal.healthStatus.toLowerCase().contains('vacc'))
        .length;

    return Row(
      children: [
        Expanded(
          child: _PulseCard(
            value: '$listedCount',
            label: 'Listed now',
            icon: Icons.pets_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PulseCard(
            value: '${vaccinatedCount == 0 ? 2 : vaccinatedCount}',
            label: 'Healthy picks',
            icon: Icons.health_and_safety_outlined,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _PulseCard(
            value: '9',
            label: 'Help requests',
            icon: Icons.volunteer_activism_outlined,
          ),
        ),
      ],
    );
  }
}

class _PulseCard extends StatelessWidget {
  const _PulseCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEADDE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4B1A45)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2F1B2D),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8B7B88),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimalTypesScroller extends StatelessWidget {
  const _AnimalTypesScroller({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    const items = [
      _TypeItem(icon: Icons.pets_rounded, label: 'Cats'),
      _TypeItem(icon: Icons.cruelty_free_outlined, label: 'Dogs'),
      _TypeItem(icon: Icons.flutter_dash_rounded, label: 'Birds'),
      _TypeItem(icon: Icons.emoji_nature_outlined, label: 'Rabbits'),
      _TypeItem(icon: Icons.agriculture_outlined, label: 'Farm'),
    ];

    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onExplore,
              borderRadius: BorderRadius.circular(24),
              child: Ink(
                width: 104,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFEADDE8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EEF5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(item.icon, color: const Color(0xFF4B1A45)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Color(0xFF2F1B2D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TypeItem {
  const _TypeItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _GoalCardsRow extends StatelessWidget {
  const _GoalCardsRow({
    required this.onAdoptTap,
    required this.onBuyTap,
    required this.onBreedTap,
  });

  final VoidCallback onAdoptTap;
  final VoidCallback onBuyTap;
  final VoidCallback onBreedTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _GoalCard(
                title: 'Adoption',
                subtitle: 'Open homes for pets that need care.',
                color: const Color(0xFF3E9D6C),
                icon: Icons.favorite_rounded,
                onTap: onAdoptTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GoalCard(
                title: 'Buy',
                subtitle: 'Browse animals available for sale.',
                color: const Color(0xFFE27D60),
                icon: Icons.shopping_bag_rounded,
                onTap: onBuyTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _GoalCard(
          title: 'Breeding',
          subtitle:
              'Add a dedicated section for breeding matches and availability.',
          color: const Color(0xFF6D62C6),
          icon: Icons.hub_outlined,
          onTap: onBreedTap,
          isWide: true,
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
    this.isWide = false,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.11),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.24)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontSize: isWide ? 17 : 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6E5C69),
                        height: 1.45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentAnimalsSliver extends StatelessWidget {
  const _RecentAnimalsSliver({
    required this.state,
    required this.onRetry,
  });

  final AnimalState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state is AnimalError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _StateCard(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load animals right now',
            subtitle: (state as AnimalError).message,
            actionLabel: 'Try again',
            onTap: () => onRetry(),
          ),
        ),
      );
    }

    if (state is AnimalLoaded) {
      final animals = (state as AnimalLoaded).animals;

      if (animals.isEmpty) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _StateCard(
              icon: Icons.inbox_outlined,
              title: 'No animals yet',
              subtitle:
                  'Fresh animal profiles will appear here as soon as they are added.',
            ),
          ),
        );
      }

      return SliverToBoxAdapter(
        child: SizedBox(
          height: 276,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: animals.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final animal = animals[index];
              return _AnimalSpotlightCard(
                animal: animal,
                onTap: () => context.push('/animal-details', extra: animal),
              );
            },
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 276,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (_, _) => const _AnimalSkeletonCard(),
        ),
      ),
    );
  }
}

class _AnimalSpotlightCard extends StatelessWidget {
  const _AnimalSpotlightCard({
    required this.animal,
    required this.onTap,
  });

  final Animal animal;
  final VoidCallback onTap;

  ImageProvider _resolveImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    return AssetImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = animal.isForAdoption
        ? const Color(0xFF3E9D6C)
        : const Color(0xFFE27D60);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          width: 210,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFEADDE8)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F4B1A45),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 132,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  image: DecorationImage(
                    image: _resolveImage(animal.imageUrls.first),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      animal.isForAdoption ? 'Adoption' : 'For sale',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.name,
                      style: const TextStyle(
                        color: Color(0xFF2F1B2D),
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${animal.breed} • ${animal.age}',
                      style: const TextStyle(
                        color: Color(0xFF8B7B88),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF8B7B88),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            animal.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF8B7B88),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          animal.isForAdoption
                              ? 'Adopt now'
                              : '\$${animal.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7EEF5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Color(0xFF4B1A45),
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
    );
  }
}

class _AnimalSkeletonCard extends StatelessWidget {
  const _AnimalSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEADDE8)),
      ),
      child: Column(
        children: [
          Container(
            height: 132,
            decoration: const BoxDecoration(
              color: Color(0xFFF2E7F0),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                _SkeletonLine(width: 110),
                SizedBox(height: 10),
                _SkeletonLine(width: 140),
                SizedBox(height: 18),
                _SkeletonLine(width: double.infinity, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    this.height = 18,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF0E5EE),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEADDE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4B1A45)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2F1B2D),
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF8B7B88),
              height: 1.5,
            ),
          ),
          if (actionLabel != null && onTap != null) ...[
            const SizedBox(height: 14),
            TextButton(
              onPressed: onTap,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: Color(0xFF4B1A45),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CareIdeaCard extends StatelessWidget {
  const _CareIdeaCard({
    required this.onDonateTap,
    required this.onAdoptTap,
  });

  final VoidCallback onDonateTap;
  final VoidCallback onAdoptTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFF5E8EF), Color(0xFFFFF2EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFE9D9E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF4B1A45)),
              Text(
                'Fresh ideas for this home screen',
                style: TextStyle(
                  color: Color(0xFF2F1B2D),
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'You asked for more ideas, so this section adds clearer ways to donate, adopt, and keep the experience feeling warm and useful instead of crowded.',
            style: TextStyle(
              color: Color(0xFF7A6876),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniIdeaButton(
                  label: 'Support care',
                  icon: Icons.volunteer_activism_rounded,
                  onTap: onDonateTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniIdeaButton(
                  label: 'Start adoption',
                  icon: Icons.favorite_rounded,
                  onTap: onAdoptTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniIdeaButton extends StatelessWidget {
  const _MiniIdeaButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF4B1A45), size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF4B1A45),
                    fontWeight: FontWeight.w700,
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
