// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/animal_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/fade_in_animation.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../home/data/home_content.dart';
import '../../home/logic/animal_bloc.dart';
import '../../home/widgets/animal_card.dart';
import '../../home/widgets/product_card.dart';

enum _ProfileMode { individual, business }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileMode _mode = _ProfileMode.individual;
  int _userTab = 0;
  int _shopTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthBloc>().state is Authenticated) {
        context.read<AnimalBloc>().add(FetchMyAnimals());
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/welcome-auth');
        }
      },
      child: Scaffold(
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
        body: Stack(
          children: [
            const _Backdrop(),
            SafeArea(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthLoading || authState is AuthInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (authState is! Authenticated) {
                    return const SizedBox.shrink();
                  }

                  return BlocBuilder<AnimalBloc, AnimalState>(
                    builder: (context, animalState) {
                      final listings = animalState.myAnimals.isNotEmpty
                          ? animalState.myAnimals
                          : HomeContent.featuredAnimals;

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                16,
                                20,
                                28,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInAnimation(
                                    delay: const Duration(milliseconds: 60),
                                    child: _SegmentedControl<_ProfileMode>(
                                      values: const [
                                        _ProfileMode.individual,
                                        _ProfileMode.business,
                                      ],
                                      labels: const ['Individual', 'Pet Shop'],
                                      selected: _mode,
                                      onChanged: (value) =>
                                          setState(() => _mode = value),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  AnimatedSwitcher(
                                    duration: AppMotion.medium,
                                    switchInCurve: AppMotion.emphasized,
                                    switchOutCurve: AppMotion.emphasized,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.03),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _mode == _ProfileMode.individual
                                        ? _IndividualProfileView(
                                            key: const ValueKey('individual'),
                                            user: authState.user,
                                            listings: listings,
                                            selectedTab: _userTab,
                                            onTabChanged: (value) => setState(
                                              () => _userTab = value,
                                            ),
                                            onShowMessage: _showMessage,
                                          )
                                        : _BusinessProfileView(
                                            key: const ValueKey('business'),
                                            owner: authState.user,
                                            selectedTab: _shopTab,
                                            onTabChanged: (value) => setState(
                                              () => _shopTab = value,
                                            ),
                                            onShowMessage: _showMessage,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndividualProfileView extends StatelessWidget {
  const _IndividualProfileView({
    super.key,
    required this.user,
    required this.listings,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onShowMessage,
  });

  final UserProfile user;
  final List<Animal> listings;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String> onShowMessage;

  List<String> get _interests {
    final unique = listings.map((animal) => animal.type).toSet().toList();
    return unique.isEmpty
        ? const ['Cats', 'Dogs', 'Birds']
        : unique.take(3).toList();
  }

  double get _progress {
    final checks = [
      user.name.trim().isNotEmpty,
      user.email.trim().isNotEmpty,
      user.phoneNumber.trim().isNotEmpty,
      (user.location ?? '').trim().isNotEmpty,
      (user.bio ?? '').trim().isNotEmpty,
      (user.profileImageUrl ?? '').trim().isNotEmpty,
    ];
    return checks.where((value) => value).length / checks.length;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = [
      ...HomeContent.featuredAnimals,
      ...HomeContent.adoptionSpotlights,
    ].take(4).toList();
    final requests = HomeContent.adoptionSpotlights;
    final items = switch (selectedTab) {
      0 => listings,
      1 => favorites,
      _ => requests,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInAnimation(
          delay: const Duration(milliseconds: 100),
          child: _HeroCard(
            coverImage: listings.first.imageUrls.isEmpty
                ? null
                : listings.first.imageUrls.first,
            avatarImage: user.profileImageUrl,
            title: user.name,
            badge: 'Verified user',
            subtitle: (user.bio ?? '').trim().isNotEmpty
                ? user.bio!.trim()
                : 'Pet lover focused on trusted listings, adoption, and community care.',
            meta: ['${user.location ?? 'Cairo'} • 2 km away', ..._interests],
            ratingText: '4.9 (128 reviews)',
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 150),
          child: _StatsGrid(
            items: [
              _StatData('Listings', '${listings.length}'),
              _StatData(
                'Adoptions',
                '${listings.where((a) => a.isForAdoption).length}',
              ),
              _StatData('Followers', '1.8k'),
              _StatData('Following', '126'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 200),
          child: _ActionRow(
            actions: [
              _ActionData(
                'Chat',
                Icons.chat_bubble_rounded,
                true,
                () => context.push('/chat'),
              ),
              _ActionData(
                'Call',
                Icons.call_rounded,
                false,
                () => onShowMessage(
                  user.phoneNumber.trim().isEmpty
                      ? 'Add a phone number to enable direct calls.'
                      : 'Calling ${user.phoneNumber}',
                ),
              ),
              _ActionData(
                'Map',
                Icons.map_rounded,
                false,
                () => context.push('/map'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 250),
          child: _SummaryRow(
            left: _MiniCard(
              title: 'Profile completion',
              value: '${(_progress * 100).round()}%',
              subtitle: 'Improve trust with more profile details.',
              progress: _progress,
            ),
            right: const _MiniCard(
              title: 'Wishlist',
              value: '24',
              subtitle: 'Saved animals and products ready to revisit.',
              icon: Icons.favorite_rounded,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const FadeInAnimation(
          delay: Duration(milliseconds: 300),
          child: _BadgeRow(
            labels: ['Trusted rescuer', 'Top seller', 'Verified user'],
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 350),
          child: _MapCard(
            title: 'View on map',
            subtitle:
                'Open route-based discovery for listings, helpers, and nearby community activity.',
            icon: Icons.place_rounded,
            onTap: () => context.push('/map'),
          ),
        ),
        const SizedBox(height: 22),
        FadeInAnimation(
          delay: const Duration(milliseconds: 400),
          child: _SegmentedControl<int>(
            values: const [0, 1, 2],
            labels: const ['My Listings', 'Favorites', 'Adoption Requests'],
            selected: selectedTab,
            onChanged: onTabChanged,
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 450),
          child: _AnimalGrid(
            title: selectedTab == 0
                ? 'Marketplace cards'
                : selectedTab == 1
                ? 'Saved items'
                : 'Incoming requests',
            subtitle: selectedTab == 0
                ? 'Same premium card language as the marketplace.'
                : selectedTab == 1
                ? 'Wishlist-ready glass cards with quick visual scanning.'
                : 'Adoption-focused cards with the same trusted layout.',
            animals: items,
          ),
        ),
      ],
    );
  }
}

class _BusinessProfileView extends StatelessWidget {
  const _BusinessProfileView({
    super.key,
    required this.owner,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onShowMessage,
  });

  final UserProfile owner;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String> onShowMessage;

  List<HomeProductData> get _products => List<HomeProductData>.generate(
    8,
    (index) => HomeContent.products[index % 4],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInAnimation(
          delay: const Duration(milliseconds: 100),
          child: _HeroCard(
            coverImage:
                'https://images.unsplash.com/photo-1583512603806-077998240c7a?auto=format&fit=crop&w=1400&q=80',
            title: 'Animal Connect Pet House',
            badge: 'Trusted shop',
            subtitle:
                'Professional storefront for supplies, services, and pet care essentials with clean product presentation.',
            meta: [
              '${owner.location ?? 'Downtown Cairo'} • 2.4 km away',
              '10 AM - 10 PM',
              owner.phoneNumber.isEmpty
                  ? '+20 100 555 0198'
                  : owner.phoneNumber,
            ],
            ratingText: '4.9 (486 reviews)',
            isShop: true,
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 150),
          child: _StatsGrid(
            items: const [
              _StatData('Products', '128'),
              _StatData('Reviews', '486'),
              _StatData('Followers', '8.4k'),
              _StatData('Services', '12'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 200),
          child: _ActionRow(
            actions: [
              _ActionData(
                'Chat',
                Icons.chat_bubble_rounded,
                true,
                () => context.push('/chat'),
              ),
              _ActionData(
                'Call',
                Icons.call_rounded,
                false,
                () => onShowMessage('Calling shop support'),
              ),
              _ActionData(
                'Directions',
                Icons.near_me_rounded,
                false,
                () => context.push('/map'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const FadeInAnimation(
          delay: Duration(milliseconds: 250),
          child: _BadgeRow(
            labels: ['Top seller', 'Trusted shop', 'Verified business'],
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 300),
          child: _InfoGrid(
            items: [
              _InfoData(
                'Address',
                owner.location ?? 'Downtown Cairo',
                Icons.place_rounded,
              ),
              const _InfoData('Distance', '2.4 km away', Icons.route_rounded),
              const _InfoData('Hours', '10 AM - 10 PM', Icons.schedule_rounded),
              _InfoData(
                'Contact',
                owner.phoneNumber.isEmpty
                    ? '+20 100 555 0198'
                    : owner.phoneNumber,
                Icons.call_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const FadeInAnimation(
          delay: Duration(milliseconds: 350),
          child: _ServicesCard(),
        ),
        const SizedBox(height: 22),
        FadeInAnimation(
          delay: const Duration(milliseconds: 400),
          child: _SegmentedControl<int>(
            values: const [0, 1, 2],
            labels: const ['Products', 'Reviews', 'About'],
            selected: selectedTab,
            onChanged: onTabChanged,
          ),
        ),
        const SizedBox(height: 18),
        FadeInAnimation(
          delay: const Duration(milliseconds: 450),
          child: switch (selectedTab) {
            0 => _ProductGrid(products: _products),
            1 => const _ReviewsSection(),
            _ => const _AboutSection(),
          },
        ),
      ],
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget orb(double size, Color color) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(isDark ? 0.16 : 0.24),
              Colors.transparent,
            ],
          ),
        ),
      );
    }

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -20,
            child: orb(220, const Color(0xFF6FA6A3)),
          ),
          Positioned(
            top: 180,
            left: -70,
            child: orb(180, const Color(0xFFE2B07C)),
          ),
          Positioned(
            bottom: -60,
            right: -50,
            child: orb(210, const Color(0xFF6B8796)),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.badge,
    required this.subtitle,
    required this.meta,
    required this.ratingText,
    this.coverImage,
    this.avatarImage,
    this.isShop = false,
  });

  final String title;
  final String badge;
  final String subtitle;
  final List<String> meta;
  final String ratingText;
  final String? coverImage;
  final String? avatarImage;
  final bool isShop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(30),
      blurSigma: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: SizedBox(
              height: 206,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppMedia(imageUrl: coverImage),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.18),
                          Colors.black.withOpacity(0.42),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.24),
                                ),
                              ),
                              child: ClipOval(
                                child: isShop
                                    ? const DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF2A7C7E),
                                              Color(0xFFE2B07C),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.storefront_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      )
                                    : avatarImage == null ||
                                          avatarImage!.isEmpty
                                    ? DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              scheme.primary.withOpacity(0.9),
                                              scheme.secondary.withOpacity(0.9),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            title.characters.first
                                                .toUpperCase(),
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      )
                                    : AppMedia(imageUrl: avatarImage),
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF58C57D),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ChipText(label: badge),
                              const SizedBox(height: 10),
                              Text(
                                title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD37E),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    ratingText,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.86),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: meta
                      .map((value) => _ChipText(label: value, filled: false))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.items});

  final List<_StatData> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: (MediaQuery.sizeOf(context).width - 64) / 2,
              child: GlassPanel(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.actions});

  final List<_ActionData> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(actions.length, (index) {
        final action = actions[index];
        final scheme = Theme.of(context).colorScheme;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == actions.length - 1 ? 0 : 12,
            ),
            child: ScaleTap(
              onTap: action.onTap,
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                borderRadius: BorderRadius.circular(22),
                gradientColors: action.primary
                    ? [
                        scheme.primary.withOpacity(0.2),
                        scheme.secondary.withOpacity(0.14),
                      ]
                    : null,
                child: Column(
                  children: [
                    Icon(
                      action.icon,
                      color: action.primary ? Colors.white : scheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: action.primary ? Colors.white : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 560;
    if (narrow) {
      return Column(children: [left, const SizedBox(height: 12), right]);
    }
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.icon,
    this.progress,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData? icon;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: theme.colorScheme.secondary),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(value: progress, minHeight: 10),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: labels.map((label) => _ChipText(label: label)).toList(),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.all(18),
        borderRadius: BorderRadius.circular(28),
        gradientColors: const [Color(0x332A7C7E), Color(0x22E2B07C)],
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.84),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}

class _SegmentedControl<T> extends StatelessWidget {
  const _SegmentedControl({
    required this.values,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<T> values;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(6),
      borderRadius: BorderRadius.circular(22),
      child: Row(
        children: List.generate(values.length, (index) {
          final active = values[index] == selected;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == values.length - 1 ? 0 : 8,
              ),
              child: ScaleTap(
                onTap: () => onChanged(values[index]),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  curve: AppMotion.emphasized,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: active
                        ? LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.16),
                              Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.12),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      labels[index],
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: active
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AnimalGrid extends StatelessWidget {
  const _AnimalGrid({
    required this.title,
    required this.subtitle,
    required this.animals,
  });

  final String title;
  final String subtitle;
  final List<Animal> animals;

  @override
  Widget build(BuildContext context) {
    final items = animals.isEmpty
        ? HomeContent.featuredAnimals.take(2).toList()
        : animals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 740 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 320,
              ),
              itemBuilder: (context, index) {
                final animal = items[index];
                return AnimalCard(
                  animal: animal,
                  heroTag: 'profile-${animal.id}-$index',
                  onTap: () => context.push('/animal-details', extra: animal),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoData> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: (MediaQuery.sizeOf(context).width - 64) / 2,
              child: GlassPanel(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ServicesCard extends StatelessWidget {
  const _ServicesCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services offered',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ChipText(label: 'Premium pet food', filled: false),
              _ChipText(label: 'Accessories', filled: false),
              _ChipText(label: 'Grooming', filled: false),
              _ChipText(label: 'Nearby helpers', filled: false),
              _ChipText(label: 'Adoption support', filled: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<HomeProductData> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All products',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'A professional storefront layout keeps the entire catalog readable and premium.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 740 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 300,
              ),
              itemBuilder: (context, index) {
                final item = products[index];
                return ProductCard(
                  data: item,
                  onTap: () =>
                      context.push('/product-details', extra: item.product),
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.product.name} added to cart'),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ReviewCard(
          name: 'Nour Salem',
          text:
              'Fast responses, thoughtful recommendations, and a clean storefront that makes browsing easy.',
        ),
        SizedBox(height: 12),
        _ReviewCard(
          name: 'Omar Tarek',
          text: 'Professional shop layout and very clear product presentation.',
        ),
        SizedBox(height: 12),
        _ReviewCard(
          name: 'Maya Hany',
          text:
              'Strong trust signals, quick support, and premium product organization.',
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassPanel(
          padding: const EdgeInsets.all(18),
          borderRadius: BorderRadius.circular(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About the shop',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Animal Connect Pet House is designed to showcase all products in a clear, professional grid while keeping services, reviews, and trust indicators easy to understand.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _MapCard(
          title: 'Get directions',
          subtitle: 'Open the map and head directly to the storefront.',
          icon: Icons.near_me_rounded,
          onTap: () => context.push('/map'),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.name, required this.text});

  final String name;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.12),
                child: Text(
                  name.characters.first.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD37E),
                size: 18,
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD37E),
                size: 18,
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD37E),
                size: 18,
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD37E),
                size: 18,
              ),
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD37E),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipText extends StatelessWidget {
  const _ChipText({required this.label, this.filled = true});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      shadowOpacity: 0,
      gradientColors: filled
          ? [
              scheme.primary.withOpacity(0.14),
              scheme.secondary.withOpacity(0.08),
            ]
          : null,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: filled
              ? scheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatData {
  const _StatData(this.label, this.value);

  final String label;
  final String value;
}

class _ActionData {
  const _ActionData(this.label, this.icon, this.primary, this.onTap);

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;
}

class _InfoData {
  const _InfoData(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;
}
