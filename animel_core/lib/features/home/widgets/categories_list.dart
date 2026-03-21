// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../data/home_content.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<HomeCategoryData> items;
  final ValueChanged<HomeCategoryData> onSelected;

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return _CategoryItem(
            item: item,
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onSelected(item);
            },
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  const _CategoryItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final HomeCategoryData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: AppMotion.fast,
        curve: AppMotion.emphasized,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.emphasized,
          width: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? scheme.primary.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.emphasized,
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? scheme.primary.withOpacity(0.14)
                      : widget.item.tint,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft(
                    widget.item.tint,
                    opacity: widget.isSelected ? 0.16 : 0.1,
                  ),
                ),
                child: Icon(
                  widget.item.icon,
                  color: widget.isSelected
                      ? scheme.primary
                      : theme.colorScheme.onSurface,
                  size: 28,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.isSelected
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
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
