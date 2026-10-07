import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/session/session_scope.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/core/utils/app_formatters.dart';
import 'package:store_app/core/widgets/app_button.dart';
import 'package:store_app/core/widgets/network_image_view.dart';

/// Home header: greeting, avatar, favourites badge and a logout action.
///
/// Uses `ListenableBuilder` on [SessionStore] so the avatar/name react to the
/// session without pulling in another package or rebuilding the whole page.
class ProductsHeader extends StatelessWidget {
  const ProductsHeader({
    required this.onLogout,
    super.key,
    this.productCount = 0,
    this.favoriteCount = 0,
  });

  final VoidCallback onLogout;
  final int productCount;
  final int favoriteCount;

  @override
  Widget build(BuildContext context) {
    // `SessionScope.of` subscribes: the header rebuilds on sign in / sign out.
    final session = SessionScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppFormatters.greeting(DateTime.now()),
                  style: context.texts.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  session.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$productCount ${AppStrings.productsCount}',
                  style: context.texts.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.favorite_rounded,
            badgeCount: favoriteCount,
            tooltip: AppStrings.favorites,
            onPressed: () => _showFavoritesHint(context),
          ),
          const SizedBox(width: AppSpacing.xs),
          AppIconButton(
            icon: Icons.logout_rounded,
            tooltip: AppStrings.logout,
            onPressed: onLogout,
          ),
          const SizedBox(width: AppSpacing.xs),
          AppAvatar(initials: session.initials),
        ],
      ),
    );
  }

  void _showFavoritesHint(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _FavoritesSheet(count: favoriteCount),
    );
  }
}

class _FavoritesSheet extends StatelessWidget {
  const _FavoritesSheet({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.scheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.favorite_rounded,
                size: 40,
                color: context.scheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(AppStrings.favorites, style: context.texts.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$count ${AppStrings.productsCount}',
                style: context.texts.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Close',
                expand: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
