// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/user_journey.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/user_repository.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../auth/logic/auth_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final UserRepository _userRepository = UserRepository();

  _PeopleFilter _activeFilter = _PeopleFilter.all;
  List<UserProfile> _users = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNearbyUsers());
  }

  Future<void> _loadNearbyUsers() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      if (!mounted) return;
      setState(() {
        _users = const [];
        _isLoading = false;
        _errorMessage = 'Please sign in again to load nearby people.';
      });
      return;
    }

    if ((authState.user.location ?? '').trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _users = const [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _userRepository.getNearbyUsers(
        journey: _activeFilter.storageValue,
      );
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _users = const [];
        _isLoading = false;
        _errorMessage = error.toString().replaceFirst('ApiException: ', '');
      });
    }
  }

  void _updateFilter(_PeopleFilter filter) {
    if (_activeFilter == filter) return;
    setState(() => _activeFilter = filter);
    _loadNearbyUsers();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final hasLocation = (user?.location ?? '').trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppPalette.shell,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadNearbyUsers,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCard(
                        location: user?.location,
                        resultCount: _users.length,
                        onEditLocation: () =>
                            context.push('/profile/account/edit'),
                      ),
                      const SizedBox(height: 18),
                      _FilterRow(
                        activeFilter: _activeFilter,
                        onFilterChanged: _updateFilter,
                      ),
                      const SizedBox(height: 18),
                      if (!hasLocation)
                        _MissingLocationCard(
                          onEditLocation: () =>
                              context.push('/profile/account/edit'),
                        )
                      else if (_isLoading)
                        const _LoadingCard()
                      else if (_errorMessage != null)
                        _ErrorCard(
                          message: _errorMessage!,
                          onRetry: _loadNearbyUsers,
                        )
                      else if (_users.isEmpty)
                        _EmptyCard(
                          filter: _activeFilter,
                          onResetFilter: () => _updateFilter(_PeopleFilter.all),
                        )
                      else
                        Text(
                          'Nearby people',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                    ],
                  ),
                ),
              ),
              if (hasLocation &&
                  !_isLoading &&
                  _errorMessage == null &&
                  _users.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 14);
                      }

                      final nearbyUser = _users[index ~/ 2];
                      return _NearbyUserCard(user: nearbyUser);
                    }, childCount: (_users.length * 2) - 1),
                  ),
                )
              else
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.location,
    required this.resultCount,
    required this.onEditLocation,
  });

  final String? location;
  final int resultCount;
  final VoidCallback onEditLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppPalette.plumDeep, AppPalette.magenta, AppPalette.sunset],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppShadows.soft(AppPalette.plumDeep, opacity: 0.18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearby community',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location == null || location!.trim().isEmpty
                          ? 'Set your location to discover people around you.'
                          : 'Based on ${location!.trim()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.84),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Find adopters, buyers, and pet owners close to your area without opening a map.',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroPill(
                icon: Icons.place_outlined,
                label: location == null || location!.trim().isEmpty
                    ? 'Location not set'
                    : location!.trim(),
              ),
              _HeroPill(
                icon: Icons.groups_rounded,
                label: '$resultCount nearby results',
              ),
              _HeroPill(icon: Icons.map, label: 'Map hidden'),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onEditLocation,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.28)),
              minimumSize: const Size.fromHeight(44),
            ),
            icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
            label: const Text('Update my location'),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.activeFilter, required this.onFilterChanged});

  final _PeopleFilter activeFilter;
  final ValueChanged<_PeopleFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filters = _PeopleFilter.values;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == activeFilter;
          return InkWell(
            onTap: () => onFilterChanged(filter),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppMotion.emphasized,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? scheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: isSelected
                      ? scheme.primary
                      : scheme.outlineVariant.withOpacity(0.9),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 16,
                    color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    filter.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? Colors.white : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NearbyUserCard extends StatelessWidget {
  const _NearbyUserCard({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final journey = user.journey;
    final accent = journey?.accent ?? AppPalette.indigo;
    final hasAvatar =
        user.profileImageUrl != null &&
        user.profileImageUrl!.isNotEmpty &&
        user.profileImageUrl!.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: AppShadows.soft(Colors.black, opacity: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: accent.withOpacity(0.12),
                backgroundImage: hasAvatar
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: hasAvatar
                    ? null
                    : Text(
                        user.name.isEmpty
                            ? 'A'
                            : user.name.characters.first.toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.location?.trim().isNotEmpty == true
                          ? user.location!.trim()
                          : 'Location not available',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (journey != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    journey.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6FA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user.bio?.trim().isNotEmpty == true
                        ? user.bio!.trim()
                        : journey?.profileSummary ??
                              'Available nearby for pet-related community support.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(
                icon: Icons.phone_outlined,
                label: user.phoneNumber,
                accent: accent,
              ),
              if (user.email.isNotEmpty)
                _InfoChip(
                  icon: Icons.mail_outline_rounded,
                  label: user.email,
                  accent: accent,
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(
                '/chat-detail',
                extra: {'userName': user.name, 'userId': user.id},
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text('Start chat'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 210),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingLocationCard extends StatelessWidget {
  const _MissingLocationCard({required this.onEditLocation});

  final VoidCallback onEditLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your location first',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nearby users are matched using the location written in your profile, so add your area first and then come back here.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onEditLocation,
            icon: const Icon(Icons.edit_location_alt_outlined),
            label: const Text('Open profile settings'),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 36),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Could not load nearby people',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.filter, required this.onResetFilter});

  final _PeopleFilter filter;
  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No nearby users yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filter == _PeopleFilter.all
                ? 'No users with matching nearby locations appeared yet.'
                : 'No users matched the selected filter near your area.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          if (filter != _PeopleFilter.all) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onResetFilter,
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Show all users'),
            ),
          ],
        ],
      ),
    );
  }
}

enum _PeopleFilter { all, petOwners, buyers, adopters }

extension on _PeopleFilter {
  String get label {
    switch (this) {
      case _PeopleFilter.all:
        return 'All';
      case _PeopleFilter.petOwners:
        return 'Owners';
      case _PeopleFilter.buyers:
        return 'Buyers';
      case _PeopleFilter.adopters:
        return 'Adopters';
    }
  }

  IconData get icon {
    switch (this) {
      case _PeopleFilter.all:
        return Icons.apps_rounded;
      case _PeopleFilter.petOwners:
        return Icons.pets_rounded;
      case _PeopleFilter.buyers:
        return Icons.storefront_rounded;
      case _PeopleFilter.adopters:
        return Icons.favorite_rounded;
    }
  }

  String? get storageValue {
    switch (this) {
      case _PeopleFilter.all:
        return null;
      case _PeopleFilter.petOwners:
        return UserJourney.petOwner.storageValue;
      case _PeopleFilter.buyers:
        return UserJourney.buyer.storageValue;
      case _PeopleFilter.adopters:
        return UserJourney.adopter.storageValue;
    }
  }
}
