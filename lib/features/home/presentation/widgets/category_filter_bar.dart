import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/widgets/network_image_view.dart';

/// Horizontally scrollable category filter built from real API data.
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox(height: AppSpacing.xs);
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          // Index 0 is the "All" pseudo-category.
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];
          final isSelected = isAll
              ? selectedCategory == null
              : selectedCategory == category;

          return Center(
            child: AppFilterChip(
              label: isAll ? AppStrings.allCategories : _titleCase(category!),
              selected: isSelected,
              onTap: () => onSelected(isAll ? null : category),
            ),
          );
        },
      ),
    );
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
