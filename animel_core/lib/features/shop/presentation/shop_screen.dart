import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/product_model.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_media.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../logic/shop_bloc.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                        Text(
                          'Animal Supplies',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Curated products for feeding, care, wellness, and play with a cleaner buying experience.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF4B88B9),
                                Color.alphaBlend(
                                  scheme.secondary.withOpacity(0.22),
                                  const Color(0xFF4B88B9),
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: AppShadows.soft(
                              const Color(0xFF4B88B9),
                              opacity: 0.18,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shop essentials',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${state.products.length} products available',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${state.cart.itemCount} items in cart • \$${state.cart.total.toStringAsFixed(0)} total',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(
                                              0.84,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search food, toys, and essentials',
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
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = _selectedCategory == category;
                              return ChoiceChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => _selectedCategory = category);
                                  _fetch();
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  const SliverToBoxAdapter(
                    child: LoadingWidget(
                      message: 'Preparing product recommendations',
                    ),
                  )
                else if (state.errorMessage != null)
                  SliverToBoxAdapter(
                    child: ErrorStateWidget(
                      message: state.errorMessage!,
                      onRetry: _fetch,
                    ),
                  )
                else if (state.products.isEmpty)
                  const SliverToBoxAdapter(
                    child: EmptyStateWidget(
                      title: 'No products found',
                      message:
                          'Try another search or switch categories for more results.',
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

                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.66,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _ProductCard(product: state.products[index]),
                            childCount: state.products.length,
                          ),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final imageUrl = product.imageUrl.isEmpty ? null : product.imageUrl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/product-details', extra: product),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outlineVariant),
            boxShadow: AppShadows.soft(Colors.black, opacity: 0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppMedia(
                  imageUrl: imageUrl,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        product.category,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.animalType.isEmpty
                          ? 'For everyday pet care'
                          : 'Best for ${product.animalType}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: () {
                            context.read<ShopBloc>().add(
                              AddToCartRequested(product.id),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Add'),
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
