import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_durations.dart';
import 'package:store_app/core/constants/app_radii.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/core/utils/app_formatters.dart';
import 'package:store_app/core/widgets/app_button.dart';
import 'package:store_app/core/widgets/app_logo.dart';
import 'package:store_app/core/widgets/network_image_view.dart';
import 'package:store_app/features/home/domain/entities/product.dart';

/// Product card: the most reused widget in the app.
///
/// Improvements over the original `ProductItem`:
/// * no more harsh orange/purple gradient painted over the whole card,
/// * a real Hero animation into the details page,
/// * favourite toggle + add-to-cart affordances with animated feedback,
/// * discount badge, category label and stock awareness,
/// * and a layout that **cannot** overflow (flexible image + clamped text).
class ProductCard extends StatefulWidget {
  const ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.onAddToCart,
    super.key,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  /// Shared by the card and the details page so the Hero tags match.
  static String heroTag(int productId) => 'product-image-$productId';

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final tokens = context.appColors;
    final scheme = context.scheme;
    final isDark = scheme.brightness == Brightness.dark;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: AppDurations.instant,
      curve: AppDurations.standard,
      child: Material(
        color: isDark ? scheme.surfaceContainerHighest : scheme.surface,
        borderRadius: AppRadii.large,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          splashColor: tokens.ripple,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadii.large,
              border: Border.all(color: tokens.divider),
              boxShadow: <BoxShadow>[tokens.softShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _ImageArea(
                    product: product,
                    isFavorite: widget.isFavorite,
                    onFavoriteToggle: widget.onFavoriteToggle,
                  ),
                ),
                _Content(product: product, onAddToCart: widget.onAddToCart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Image + discount/favourite overlays.
class _ImageArea extends StatelessWidget {
  const _ImageArea({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final hasDiscount =
        (product.discountPercentage ?? 0) > 0;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Hero(
          tag: ProductCard.heroTag(product.id),
          child: AppNetworkImage(url: product.thumbnail),
        ),
        // Scrim keeps the badges readable on bright photos.
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withValues(alpha: 0.20),
                  Colors.transparent,
                ],
                stops: const <double>[0, 0.32],
              ),
            ),
          ),
        ),
        if (hasDiscount)
          Positioned(
            top: AppSpacing.xs,
            left: AppSpacing.xs,
            child: AppBadge(
              label: '-${product.discountPercentage!.toStringAsFixed(0)}%',
              icon: Icons.local_offer_rounded,
              gradient: tokens.freshGradient,
            ),
          ),
        Positioned(
          top: AppSpacing.xs,
          right: AppSpacing.xs,
          child: AppChipIconButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            isActive: isFavorite,
            onPressed: onFavoriteToggle,
          ),
        ),
      ],
    );
  }
}

/// Category, title, price and the add-to-cart button.
class _Content extends StatelessWidget {
  const _Content({required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            product.category.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.texts.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            product.title,
            // Clamped text = no RenderFlex overflow at any text scale.
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.texts.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  AppFormatters.price(product.finalPrice),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.texts.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              _AddToCartButton(
                enabled: product.isInStock,
                onPressed: onAddToCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: enabled ? context.appColors.brandGradient : null,
        color: enabled ? null : scheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: enabled
            ? <BoxShadow>[
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: Icon(
            enabled
                ? Icons.add_shopping_cart_rounded
                : Icons.remove_shopping_cart_rounded,
            size: 17,
            color: enabled ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}