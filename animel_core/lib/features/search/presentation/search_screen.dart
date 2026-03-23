import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/models/animal_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../home/data/home_content.dart';
import '../../home/logic/animal_bloc.dart';
import '../../home/widgets/animal_card.dart';
import '../../home/widgets/product_card.dart';
import '../../shop/logic/shop_bloc.dart';

part '../widgets/search_screen_sections.dart';

enum _SearchFilter { all, products, listings, helpers }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  _SearchFilter _activeFilter = _SearchFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(FetchProducts());
    context.read<AnimalBloc>().add(const FetchAnimals());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 320), () {
      final query = _searchController.text.trim();
      context.read<ShopBloc>().add(FetchProducts(query: query));
      context.read<AnimalBloc>().add(FetchAnimals(query: query));
    });
  }

  void _retrySearch() {
    final query = _searchController.text.trim();
    context.read<ShopBloc>().add(FetchProducts(query: query));
    context.read<AnimalBloc>().add(FetchAnimals(query: query));
  }

  void _activateFilter(_SearchFilter filter) {
    if (_activeFilter == filter) return;
    setState(() => _activeFilter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<ShopBloc, ShopState>(
              listenWhen: (previous, current) =>
                  previous.successMessage != current.successMessage &&
                  current.successMessage != null,
              listener: (context, state) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
                context.read<ShopBloc>().add(ClearShopMessage());
              },
            ),
          ],
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, shopState) {
              return BlocBuilder<AnimalBloc, AnimalState>(
                builder: (context, animalState) {
                  final products = shopState.products.isNotEmpty
                      ? shopState.products
                      : HomeContent.products.map((item) => item.product).toList();
                  final animals = animalState.animals.isNotEmpty
                      ? animalState.animals
                      : HomeContent.featuredAnimals;
                  final helpers = _filterHelpers(
                    HomeContent.serviceHelpers,
                    _searchController.text.trim(),
                  );

                  final isLoading = shopState.isLoading || animalState.isLoading;
                  final errorMessage =
                      shopState.errorMessage ?? animalState.errorMessage;

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: AppSpacing.screenPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchHeroCard(
                                title: copy.searchExperienceTitle,
                                subtitle: copy.searchExperienceSubtitle,
                                productsCount: products.length,
                                animalsCount: animals.length,
                                helpersCount: helpers.length,
                              ),
                              const SizedBox(height: 18),
                              SearchQueryBar(
                                controller: _searchController,
                                hint: copy.searchHint,
                                subhint: copy.searchSubhint,
                                onChanged: _onSearchChanged,
                                onClear: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              ),
                              const SizedBox(height: 16),
                              SearchFilterTabs(
                                activeFilter: _activeFilter,
                                onChanged: _activateFilter,
                              ),
                              const SizedBox(height: 16),
                              SearchExplorerCards(
                                activeFilter: _activeFilter,
                                productsCount: products.length,
                                animalsCount: animals.length,
                                helpersCount: helpers.length,
                                onSelectFilter: _activateFilter,
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                      ),
                      if (isLoading)
                        SliverToBoxAdapter(
                          child: LoadingWidget(message: copy.loadingProducts),
                        )
                      else if (errorMessage != null)
                        SliverToBoxAdapter(
                          child: ErrorStateWidget(
                            title: copy.tryAgain,
                            message: errorMessage,
                            onRetry: _retrySearch,
                          ),
                        )
                      else if (_isEmpty(
                        products: products,
                        animals: animals,
                        helpers: helpers,
                        filter: _activeFilter,
                      ))
                        SliverToBoxAdapter(
                          child: EmptyStateWidget(
                            title: copy.noSearchResultsTitle,
                            message: copy.noSearchResultsMessage,
                            icon: Icons.travel_explore_rounded,
                            actionLabel: copy.resetSearch,
                            onAction: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SearchResultSummaryBar(
                                  filter: _activeFilter,
                                  productsCount: products.length,
                                  animalsCount: animals.length,
                                  helpersCount: helpers.length,
                                ),
                                const SizedBox(height: 20),
                                ..._buildSections(
                                  context,
                                  products: products,
                                  animals: animals,
                                  helpers: helpers,
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
      ),
    );
  }

  List<Widget> _buildSections(
    BuildContext context, {
    required List<Product> products,
    required List<Animal> animals,
    required List<NearbyServiceData> helpers,
  }) {
    final sections = <Widget>[];

    void addSection(Widget child) {
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 24));
      }
      sections.add(child);
    }

    final productCards = products
        .map(
          (product) => HomeProductData(
            product: product,
            rating: 4.7,
            accentLabel: context.copy.trendingNow,
          ),
        )
        .toList();

    if (_activeFilter == _SearchFilter.all ||
        _activeFilter == _SearchFilter.products) {
      addSection(SearchProductsSection(items: productCards));
    }

    if (_activeFilter == _SearchFilter.all ||
        _activeFilter == _SearchFilter.listings) {
      addSection(SearchAnimalsSection(animals: animals));
    }

    if (_activeFilter == _SearchFilter.all ||
        _activeFilter == _SearchFilter.helpers) {
      addSection(SearchHelpersSection(helpers: helpers));
    }

    return sections;
  }

  List<NearbyServiceData> _filterHelpers(
    List<NearbyServiceData> items,
    String query,
  ) {
    if (query.isEmpty) return items;
    final normalized = query.toLowerCase();

    return items.where((item) {
      return item.title.toLowerCase().contains(normalized) ||
          item.subtitle.toLowerCase().contains(normalized) ||
          item.badge.toLowerCase().contains(normalized);
    }).toList();
  }

  bool _isEmpty({
    required List<Product> products,
    required List<Animal> animals,
    required List<NearbyServiceData> helpers,
    required _SearchFilter filter,
  }) {
    return switch (filter) {
      _SearchFilter.products => products.isEmpty,
      _SearchFilter.listings => animals.isEmpty,
      _SearchFilter.helpers => helpers.isEmpty,
      _ => products.isEmpty && animals.isEmpty && helpers.isEmpty,
    };
  }
}
