// ignore_for_file: unused_local_variable, unused_element, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../favorites/logic/favorites_cubit.dart';
import '../logic/adoption_bloc.dart';

part '../widgets/adoption_list_screen_sections.dart';

class AdoptionListScreen extends StatefulWidget {
  const AdoptionListScreen({super.key});

  @override
  State<AdoptionListScreen> createState() => _AdoptionListScreenState();
}

class _AdoptionListScreenState extends State<AdoptionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _fetch() {
    context.read<AdoptionBloc>().add(
      FetchAdoptionAnimals(query: _searchController.text.trim()),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 320), _fetch);
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: BlocBuilder<AdoptionBloc, AdoptionState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdoptionListHeroSection(
                          animalsCount: state.animals.length,
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: copy.searchAdoptionListings,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                      _fetch();
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  SliverToBoxAdapter(
                    child: LoadingWidget(
                      message: copy.loadingAdoptionCompanions,
                    ),
                  )
                else if (state.errorMessage != null)
                  SliverToBoxAdapter(
                    child: ErrorStateWidget(
                      message: state.errorMessage!,
                      onRetry: _fetch,
                    ),
                  )
                else if (state.animals.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      title: copy.noAdoptionListings,
                      message: copy.noAdoptionListingsMessage,
                      icon: Icons.pets_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index.isOdd) {
                          return const SizedBox(height: 14);
                        }

                        return AdoptionListCard(
                          animal: state.animals[index ~/ 2],
                        );
                      }, childCount: (state.animals.length * 2) - 1),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AdoptionListCard extends StatelessWidget {
  const _AdoptionListCard({required this.animal});

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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
