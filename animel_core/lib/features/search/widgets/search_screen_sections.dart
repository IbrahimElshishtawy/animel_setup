// ignore_for_file: unnecessary_brace_in_string_interps, library_private_types_in_public_api, deprecated_member_use

part of '../presentation/search_screen.dart';

class SearchHeroCard extends StatelessWidget {
  const SearchHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.productsCount,
    required this.animalsCount,
    required this.helpersCount,
  });

  final String title;
  final String subtitle;
  final int productsCount;
  final int animalsCount;
  final int helpersCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(28),
      gradientColors: [
        scheme.primary.withOpacity(0.14),
        scheme.secondary.withOpacity(0.08),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SearchHeroMetric(
                  label: context.copy.products,
                  value: '$productsCount',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SearchHeroMetric(
                  label: context.copy.listings,
                  value: '$animalsCount',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SearchHeroMetric(
                  label: context.copy.helpers,
                  value: '$helpersCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchHeroMetric extends StatelessWidget {
  const _SearchHeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      borderRadius: BorderRadius.circular(18),
      shadowOpacity: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchQueryBar extends StatelessWidget {
  const SearchQueryBar({
    super.key,
    required this.controller,
    required this.hint,
    required this.subhint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final String subhint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(9),
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.search_rounded, color: scheme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                ),
                Text(
                  subhint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded),
              color: scheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

class SearchFilterTabs extends StatelessWidget {
  const SearchFilterTabs({
    super.key,
    required this.activeFilter,
    required this.onChanged,
  });

  final _SearchFilter activeFilter;
  final ValueChanged<_SearchFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = [
      (_SearchFilter.all, context.copy.allResults),
      (_SearchFilter.products, context.copy.products),
      (_SearchFilter.listings, context.copy.listings),
      (_SearchFilter.helpers, context.copy.helpers),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.$1 == activeFilter;

          return ScaleTap(
            onTap: () => onChanged(item.$1),
            child: GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              gradientColors: isSelected
                  ? [
                      Theme.of(context).colorScheme.primary.withOpacity(0.14),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                    ]
                  : null,
              shadowOpacity: 0,
              child: Text(
                item.$2,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchExplorerCards extends StatelessWidget {
  const SearchExplorerCards({
    super.key,
    required this.activeFilter,
    required this.productsCount,
    required this.animalsCount,
    required this.helpersCount,
    required this.onSelectFilter,
  });

  final _SearchFilter activeFilter;
  final int productsCount;
  final int animalsCount;
  final int helpersCount;
  final ValueChanged<_SearchFilter> onSelectFilter;

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        _SearchFilter.products,
        context.copy.shopCollection,
        context.copy.searchProductsLabel,
        '${productsCount}',
        Icons.inventory_2_outlined,
      ),
      (
        _SearchFilter.listings,
        context.copy.adoptionSpotlight,
        context.copy.searchAnimalsLabel,
        '${animalsCount}',
        Icons.pets_rounded,
      ),
      (
        _SearchFilter.helpers,
        context.copy.nearbyServices,
        context.copy.searchHelpersLabel,
        '${helpersCount}',
        Icons.support_agent_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: compact ? 1 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: compact ? 3.1 : 1.18,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];
            final isSelected = activeFilter == card.$1;

            return SearchExplorerCard(
              title: card.$2,
              subtitle: card.$3,
              value: card.$4,
              icon: card.$5,
              isSelected: isSelected,
              onTap: () =>
                  onSelectFilter(isSelected ? _SearchFilter.all : card.$1),
            );
          },
        );
      },
    );
  }
}

class SearchExplorerCard extends StatelessWidget {
  const SearchExplorerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ScaleTap(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(22),
        gradientColors: isSelected
            ? [
                scheme.primary.withOpacity(0.18),
                scheme.secondary.withOpacity(0.12),
              ]
            : null,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(isSelected ? 0.16 : 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: scheme.primary, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected ? scheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultSummaryBar extends StatelessWidget {
  const SearchResultSummaryBar({
    super.key,
    required this.filter,
    required this.productsCount,
    required this.animalsCount,
    required this.helpersCount,
  });

  final _SearchFilter filter;
  final int productsCount;
  final int animalsCount;
  final int helpersCount;

  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final count = switch (filter) {
      _SearchFilter.products => productsCount,
      _SearchFilter.listings => animalsCount,
      _SearchFilter.helpers => helpersCount,
      _ => productsCount + animalsCount + helpersCount,
    };
    final label = switch (filter) {
      _SearchFilter.products => copy.products,
      _SearchFilter.listings => copy.listings,
      _SearchFilter.helpers => copy.helpers,
      _ => copy.allResults,
    };

    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(22),
      shadowOpacity: 0,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchProductsSection extends StatelessWidget {
  const SearchProductsSection({super.key, required this.items});

  final List<HomeProductData> items;

  @override
  Widget build(BuildContext context) {
    return _SearchSectionShell(
      title: context.copy.shopCollection,
      subtitle: context.copy.shopProfessionalCatalogSubtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 760 ? 3 : 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return ProductCard(
                data: item,
                onTap: () =>
                    context.push('/product-details', extra: item.product),
              );
            },
          );
        },
      ),
    );
  }
}

class SearchAnimalsSection extends StatelessWidget {
  const SearchAnimalsSection({super.key, required this.animals});

  final List<Animal> animals;

  @override
  Widget build(BuildContext context) {
    return _SearchSectionShell(
      title: context.copy.adoptionSpotlight,
      subtitle: context.copy.searchAnimalsLabel,
      child: SizedBox(
        height: 292,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: animals.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final animal = animals[index];
            return AnimalCard(
              animal: animal,
              width: 210,
              onTap: () => context.push('/animal-details', extra: animal),
            );
          },
        ),
      ),
    );
  }
}

class SearchHelpersSection extends StatelessWidget {
  const SearchHelpersSection({super.key, required this.helpers});

  final List<NearbyServiceData> helpers;

  @override
  Widget build(BuildContext context) {
    return _SearchSectionShell(
      title: context.copy.nearbyServices,
      subtitle: context.copy.searchHelpersLabel,
      child: Column(
        children: helpers
            .map(
              (helper) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ServiceHelperCard(helper: helper),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SearchSectionShell extends StatelessWidget {
  const _SearchSectionShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _ServiceHelperCard extends StatelessWidget {
  const _ServiceHelperCard({required this.helper});

  final NearbyServiceData helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(22),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: helper.accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(helper.icon, color: helper.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  helper.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  helper.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: scheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      helper.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      helper.badge,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: helper.isOnline ? const Color(0xFF57C27E) : scheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
