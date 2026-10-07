import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_durations.dart';
import 'package:store_app/core/constants/app_radii.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/features/home/presentation/cubit/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Search field with a debounce-free, Cubit-driven query.
///
/// Declared `const` in the tree: because the widget instance is canonical,
/// rebuilding the page on every keystroke does **not** rebuild this widget -
/// only the grid does.
class ProductsSearchField extends StatefulWidget {
  const ProductsSearchField({super.key});

  @override
  State<ProductsSearchField> createState() => _ProductsSearchFieldState();
}

class _ProductsSearchFieldState extends State<ProductsSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final scheme = context.scheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          return Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: AppRadii.medium,
              border: Border.all(color: tokens.divider),
              boxShadow: <BoxShadow>[tokens.softShadow],
            ),
            child: Row(
              children: <Widget>[
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.search_rounded, size: 20, color: tokens.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    style: context.texts.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: scheme.primary,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      hintText: AppStrings.searchHint,
                      hintStyle: TextStyle(
                        color: tokens.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    onChanged: context.read<ProductsCubit>().search,
                  ),
                ),
                AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: value.text.isEmpty
                      ? const SizedBox.shrink(key: ValueKey<String>('empty'))
                      : IconButton(
                          key: const ValueKey<String>('clear'),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _controller.clear();
                            context.read<ProductsCubit>().search('');
                          },
                        ),
                ),
                const SizedBox(width: AppSpacing.xxs),
              ],
            ),
          );
        },
      ),
    );
  }
}
