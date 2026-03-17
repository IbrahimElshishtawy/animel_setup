// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/product_model.dart';
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
  String _selectedCategory = 'All';
  String _selectedAnimalType = 'All';

  static const _animalTypes = ['All', 'Cat', 'Dog', 'Bird', 'Rabbit'];
  static const _categories = ['All', 'Food', 'Toys', 'Medicine', 'Accessories'];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ShopBloc>().add(
          FetchProducts(
            query: _searchController.text,
            category: _selectedCategory,
            animalType: _selectedAnimalType,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F7),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7F3), Color(0xFFF8F3F7), Color(0xFFF2EBF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ShopHero(
                              onOpenCart: () {},
                              onOpenSearch: _fetch,
                            ),
                            const SizedBox(height: 14),
                            _ShopSearchField(
                              controller: _searchController,
                              onChanged: (_) {
                                setState(() {});
                                _fetch();
                              },
                              onClear: () {
                                setState(() {
                                  _searchController.clear();
                                });
                                _fetch();
                              },
                            ),
                            const SizedBox(height: 18),
                            const _SectionLabel(
                              title: 'Browse by Animal',
                              subtitle:
                                  'Choose the pet type first for a cleaner product list.',
                            ),
                            const SizedBox(height: 10),
                            _FilterScroller(
                              icon: Icons.pets_outlined,
                              items: _animalTypes,
                              selectedValue: _selectedAnimalType,
                              onSelected: (value) {
                                setState(() => _selectedAnimalType = value);
                                _fetch();
                              },
                            ),
                            const SizedBox(height: 16),
                            const _SectionLabel(
                              title: 'Refine by Category',
                              subtitle:
                                  'Switch between essentials, care, play, and more.',
                            ),
                            const SizedBox(height: 10),
                            _FilterScroller(
                              icon: Icons.tune_rounded,
                              items: _categories,
                              selectedValue: _selectedCategory,
                              onSelected: (value) {
                                setState(() => _selectedCategory = value);
                                _fetch();
                              },
                            ),
                            const SizedBox(height: 18),
                            const _SectionLabel(
                              title: 'Soft Picks for Today',
                              subtitle:
                                  'Curated products with a calmer and cleaner browsing experience.',
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<ShopBloc, ShopState>(
                      builder: (context, state) {
                        if (state is ShopLoading) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
                            child: LoadingWidget(),
                          );
                        }

                        if (state is ShopError) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: ErrorStateWidget(
                              message: state.message,
                              onRetry: _fetch,
                            ),
                          );
                        }

                        if (state is ShopLoaded) {
                          if (state.products.isEmpty) {
                            return const SliverFillRemaining(
                              hasScrollBody: false,
                              child: EmptyStateWidget(
                                title: 'No products found',
                                message:
                                    'Try a different animal type or category filter.',
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.82,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = state.products[index];
                                  return _ProductSoftCard(
                                    product: product,
                                    onTap: () => context.push(
                                      '/product-details',
                                      extra: product,
                                    ),
                                  );
                                },
                                childCount: state.products.length,
                              ),
                            ),
                          );
                        }

                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text('Explore curated pet supplies.'),
                          ),
                        );
                      },
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

class _ShopHero extends StatelessWidget {
  const _ShopHero({
    required this.onOpenCart,
    required this.onOpenSearch,
  });

  final VoidCallback onOpenCart;
  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF4B1A45), Color(0xFF7D355F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4B1A45),
            blurRadius: 28,
            offset: Offset(0, 12),
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
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Curated pet essentials',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onOpenCart,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Professional pet shop with smoother browsing and smarter filtering.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse by animal type, switch categories fast, and discover products that feel organized instead of crowded.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  value: '5',
                  label: 'Animal types',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  value: '4',
                  label: 'Product filters',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroStat(
                  value: 'Soft',
                  label: 'Shopping flow',
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.78),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopSearchField extends StatelessWidget {
  const _ShopSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9DCE7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F4B1A45),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search food, toys, vitamins...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
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
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2F1B2D),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF8B7B88),
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _FilterScroller extends StatelessWidget {
  const _FilterScroller({
    required this.icon,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  final IconData icon;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DBE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C4B1A45),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF7EEF5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4B1A45),
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedValue;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => onSelected(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: isSelected
                            ? const Color(0xFF4B1A45)
                            : const Color(0xFFF9F5F8),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4B1A45)
                              : const Color(0xFFF0E5EE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF6E5C69),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSoftCard extends StatelessWidget {
  const _ProductSoftCard({
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  ImageProvider _resolveImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    return AssetImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(product.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.circular(24),
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
                height: 108,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: _resolveImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      product.animalType,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF2F1B2D),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7EEF5),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              color: Color(0xFF6E5C69),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
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

  Color _accentColor(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFE27D60);
      case 'Toys':
        return const Color(0xFF4B8FA5);
      case 'Medicine':
        return const Color(0xFF3E9D6C);
      case 'Accessories':
        return const Color(0xFF7C4D9E);
      default:
        return const Color(0xFF4B1A45);
    }
  }
}
