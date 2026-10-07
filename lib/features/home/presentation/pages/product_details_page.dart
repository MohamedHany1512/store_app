import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_durations.dart';
import 'package:store_app/core/constants/app_radii.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/theme/app_theme_extension.dart';
import 'package:store_app/core/utils/app_formatters.dart';
import 'package:store_app/core/utils/responsive.dart';
import 'package:store_app/core/widgets/app_background.dart';
import 'package:store_app/core/widgets/app_button.dart';
import 'package:store_app/core/widgets/app_logo.dart';
import 'package:store_app/core/widgets/glass_card.dart';
import 'package:store_app/core/widgets/network_image_view.dart';
import 'package:store_app/core/widgets/state_views.dart';
import 'package:store_app/features/home/domain/entities/product.dart';
import 'package:store_app/features/home/presentation/widgets/product_card.dart';

/// Product details screen.
///
/// The product is resolved by id from the catalog, which keeps deep links
/// working: when it is missing the page renders a proper "not found" state
/// instead of crashing.
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product? product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;
  bool _expanded = false;
  bool _addedToCart = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: AppEmptyView(
          title: AppStrings.noProductsTitle,
          message: AppStrings.noProductsMessage,
          actionLabel: AppStrings.goBackHome,
          onAction: () => Navigator.of(context).maybePop(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: _buildContent(context, product)),
            Positioned(
              top: MediaQuery.paddingOf(context).top + AppSpacing.xs,
              left: AppSpacing.md,
              child: _CircleAction(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Side-by-side on wide screens, stacked on phones.
  Widget _buildContent(BuildContext context, Product product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xxl,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(flex: 5, child: _imageSection(product)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(flex: 6, child: _detailsSection(product)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _imageSection(product),
                        const SizedBox(height: AppSpacing.lg),
                        _detailsSection(product),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _imageSection(Product product) {
    final hasDiscount = (product.discountPercentage ?? 0) > 0;

    return Hero(
      tag: ProductCard.heroTag(product.id),
      child: ClipRRect(
        borderRadius: AppRadii.extraLarge,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AppNetworkImage(url: product.thumbnail),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const <double>[0, 0.3],
                    ),
                  ),
                ),
              ),
              if (hasDiscount)
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: AppBadge(
                    label: '-${product.discountPercentage!.toStringAsFixed(0)}%',
                    icon: Icons.local_offer_rounded,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsSection(Product product) {
    final scheme = context.scheme;
    final hasDiscount = (product.discountPercentage ?? 0) > 0;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBadge(label: product.category.toUpperCase()),
          const SizedBox(height: AppSpacing.xs),
          Text(product.title, style: context.texts.headlineSmall),
          const SizedBox(height: AppSpacing.sm),

          // --- Rating + stock -------------------------------------------------
          Row(
            children: <Widget>[
              Icon(Icons.star_rounded, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                AppFormatters.rating(product.rating),
                style: context.texts.titleSmall,
              ),
              const SizedBox(width: AppSpacing.sm),
              if (!product.isInStock)
                Text(
                  AppStrings.outOfStock,
                  style: context.texts.labelMedium?.copyWith(
                    color: context.appColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // --- Price ----------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                AppFormatters.price(product.finalPrice),
                style: context.texts.headlineMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (hasDiscount) ...<Widget>[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  AppFormatters.price(product.price),
                  style: context.texts.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // --- Expandable description ----------------------------------------
          AnimatedSize(
            duration: AppDurations.normal,
            curve: AppDurations.standard,
            alignment: Alignment.topCenter,
            child: Text(
              product.description,
              maxLines: _expanded ? null : 3,
              overflow: _expanded ? TextOverflow.clip : TextOverflow.ellipsis,
              style: context.texts.bodyMedium?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
          if (product.description.length > 90)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _expanded ? AppStrings.readLess : AppStrings.readMore,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),

          // --- Quantity + CTA --------------------------------------------------
          Row(
            children: <Widget>[
              _QuantityStepper(
                value: _quantity,
                onChanged: (value) => setState(() => _quantity = value),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: _addedToCart
                      ? AppStrings.addedToCart
                      : AppStrings.addToCart,
                  icon: _addedToCart
                      ? Icons.check_rounded
                      : Icons.shopping_cart_rounded,
                  gradient:
                      _addedToCart ? context.appColors.freshGradient : null,
                  onPressed: product.isInStock
                      ? () => setState(() => _addedToCart = true)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = AppIconButton(icon: icon, onPressed: onPressed, size: 44);

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;

    return AnimatedContainer(
      duration: AppDurations.fast,
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: context.scheme.surface,
        borderRadius: AppRadii.circle,
        border: Border.all(color: tokens.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
          ),
          // Fixed width: the stepper never resizes while tapping.
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: context.texts.titleMedium,
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            onPressed: value < 99 ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 34,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(
            icon,
            size: 18,
            color: onPressed == null
                ? context.appColors.textSecondary.withValues(alpha: 0.4)
                : context.scheme.primary,
          ),
        ),
      ),
    );
  }
}
