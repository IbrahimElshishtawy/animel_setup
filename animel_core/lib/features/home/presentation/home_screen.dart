// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/models/animal_model.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/fade_in_animation.dart';
import '../../../../core/widgets/loading_widget.dart';
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
    _fetch();
  }

  void _fetch() {
    context.read<AnimalBloc>().add(const FetchAnimals());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 80),
                      child: HomeHeader(
                        onProfileTap: () => context.go('/profile'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const FadeInAnimation(
                      delay: Duration(milliseconds: 160),
                      child: AddressField(),
                    ),
                    const SizedBox(height: 18),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 240),
                      child: _HomeHeroCard(
                        onBrowseTap: () => context.push('/animal-list'),
                        onMapTap: () => context.push('/map'),
                      ),
                    ),
                    const SizedBox(height: 26),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 320),
                      child: _SectionHeader(
                        title: 'Quick access',
                        subtitle: 'Small, clean actions for the core flows.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 400),
                      child: _ServicesGrid(
                        items: [
                          _ServiceItem(
                            title: 'Buy pets',
                            subtitle: 'New arrivals and healthy companions',
                            icon: MdiIcons.paw,
                            color: const Color(0xFFE2954C),
                            route: '/animal-list',
                          ),
                          _ServiceItem(
                            title: 'Adopt',
                            subtitle: 'Meet adoption-ready animals nearby',
                            icon: MdiIcons.heartOutline,
                            color: const Color(0xFF53A47E),
                            route: '/adopt',
                          ),
                          _ServiceItem(
                            title: 'Supplies',
                            subtitle: 'Food, toys, and everyday essentials',
                            icon: MdiIcons.shoppingOutline,
                            color: const Color(0xFF4B88B9),
                            route: '/shop',
                          ),
                          _ServiceItem(
                            title: 'Community map',
                            subtitle: 'Explore nearby pets and helpers',
                            icon: MdiIcons.mapMarkerOutline,
                            color: const Color(0xFF2E7D75),
                            route: '/map',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 480),
                      child: _SectionHeader(
                        title: 'Recently added',
                        subtitle: 'Fresh listings with a lighter, more readable layout.',
                        actionLabel: 'See all',
                        onTap: () => context.push('/animal-list'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildRecentAnimalsSliver(context),
            const SliverToBoxAdapter(child: SizedBox(height: 26)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnimalsSliver(BuildContext context) {
    return BlocBuilder<AnimalBloc, AnimalState>(
      builder: (context, state) {
        if (state is AnimalLoading) {
          return const SliverToBoxAdapter(child: LoadingWidget());
        }

        if (state is AnimalLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final animal = state.animals[index];
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 560 + (index * 90)),
                    child: _AnimalPreviewCard(animal: animal),
                  );
                },
                childCount: state.animals.length > 4 ? 4 : state.animals.length,
              ),
            ),
          );
        }

        if (state is AnimalError) {
          return SliverToBoxAdapter(
            child: ErrorStateWidget(message: state.message, onRetry: _fetch),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard({
    required this.onBrowseTap,
    required this.onMapTap,
  });

  final VoidCallback onBrowseTap;
  final VoidCallback onMapTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            Color.alphaBlend(scheme.secondary.withOpacity(0.28), scheme.primary),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.24),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Refined pet discovery',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Soft visuals, faster scanning, and a more premium home screen.',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse new pets, jump to the community map, and keep the interface light and modern.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.84),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _HeroStat(
                  value: '24h',
                  label: 'Fresh updates',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  value: 'Near',
                  label: 'Map-first search',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onBrowseTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: scheme.primary,
                    minimumSize: const Size.fromHeight(42),
                  ),
                  icon: const Icon(Icons.pets_rounded, size: 17),
                  label: const Text('Browse pets'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMapTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.26)),
                    minimumSize: const Size.fromHeight(42),
                  ),
                  icon: const Icon(Icons.map_outlined, size: 17),
                  label: const Text('Open map'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid({required this.items});

  final List<_ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.06,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _ServiceCard(item: item);
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});

  final _ServiceItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(item.route),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: item.color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimalPreviewCard extends StatelessWidget {
  const _AnimalPreviewCard({required this.animal});

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/animal-details', extra: animal),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    image: const DecorationImage(
                      image: AssetImage('assets/image/image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            animal.isForAdoption ? 'Adoption' : 'For sale',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: scheme.primary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${animal.breed} • ${animal.age}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                size: 14,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
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
                        ),
                        const SizedBox(width: 8),
                        Text(
                          animal.isForAdoption ? 'Free' : '\$${animal.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}
