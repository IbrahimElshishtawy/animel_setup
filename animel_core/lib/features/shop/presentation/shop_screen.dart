import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_copy.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../home/data/home_content.dart';
import '../../home/widgets/product_card.dart';
import '../logic/shop_bloc.dart';

part '../widgets/shop_screen_sections.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ShopBloc>();
    bloc.add(FetchCategories());
    bloc.add(FetchCart());
    _fetch();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _fetch() {
    context.read<ShopBloc>().add(
      FetchProducts(
        query: _searchController.text.trim(),
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      ),
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

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: BlocConsumer<ShopBloc, ShopState>(
          listenWhen: (previous, current) =>
              previous.successMessage != current.successMessage &&
              current.successMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            context.read<ShopBloc>().add(ClearShopMessage());
          },
          builder: (context, state) {
            final categories = state.categories.isEmpty
                ? const ['All']
                : state.categories;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShopHeroSection(
                          title: copy.animalSuppliesTitle,
                          subtitle: copy.animalSuppliesSubtitle,
                          badgeTitle: copy.shopEssentials,
                          productsCountText: copy.productsAvailable(
                            state.products.length,
                          ),
                          cartSummaryText: copy.cartSummary(
                            state.cart.itemCount,
                            state.cart.total,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ShopSearchBar(
                          controller: _searchController,
                          hintText: copy.searchShopHint,
                          onChanged: _onSearchChanged,
                          onClear: () {
                            _searchController.clear();
                            _onSearchChanged('');
                            _fetch();
                          },
                        ),
                        const SizedBox(height: 14),
                        ShopCategoryTabs(
                          categories: categories,
                          selectedCategory: _selectedCategory,
                          onSelected: (category) {
                            setState(() => _selectedCategory = category);
                            _fetch();
                          },
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  SliverToBoxAdapter(
                    child: LoadingWidget(message: copy.loadingProducts),
                  )
                else if (state.errorMessage != null)
                  SliverToBoxAdapter(
                    child: ErrorStateWidget(
                      title: copy.tryAgain,
                      message: state.errorMessage!,
                      onRetry: _fetch,
                    ),
                  )
                else if (state.products.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      title: copy.noProductsFound,
                      message: copy.noProductsFoundMessage,
                      icon: Icons.inventory_2_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.crossAxisExtent;
                        final crossAxisCount = width >= 1080
                            ? 4
                            : width >= 720
                            ? 3
                            : 2;

                        final items = state.products
                            .map(
                              (product) => HomeProductData(
                                product: product,
                                rating: 4.7,
                                accentLabel: copy.trendingNow,
                              ),
                            )
                            .toList();

                        return SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.66,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final item = items[index];
                            return ProductCard(
                              data: item,
                              onTap: () => context.push(
                                '/product-details',
                                extra: item.product,
                              ),
                              onAddToCart: () {
                                context.read<ShopBloc>().add(
                                  AddToCartRequested(item.product.id),
                                );
                              },
                            );
                          }, childCount: items.length),
                        );
                      },
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
