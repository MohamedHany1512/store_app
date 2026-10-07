import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/routing/routes.dart';
import 'package:store_app/core/utils/responsive.dart';
import 'package:store_app/core/widgets/app_background.dart';
import 'package:store_app/core/widgets/app_toast.dart';
import 'package:store_app/core/widgets/state_views.dart';
import 'package:store_app/features/home/presentation/cubit/products_cubit.dart';
import 'package:store_app/features/home/presentation/widgets/category_filter_bar.dart';
import 'package:store_app/features/home/presentation/widgets/product_card.dart';
import 'package:store_app/features/home/presentation/widgets/products_header.dart';
import 'package:store_app/features/home/presentation/widgets/products_skeleton.dart';
import 'package:store_app/features/home/presentation/widgets/products_search_field.dart';

 
 
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    // The Cubit lives above the router, so the page decides *when* to fetch.
    // `loadProducts` is idempotent: a second call only refreshes silently.
    context.read<ProductsCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    // Errors are surfaced as a toast from a listener - never from `build`.
    return BlocListener<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) =>
          current.isFailure && !previous.isFailure,
      listener: (context, state) => AppToast.error(
        context,
        state.message ?? AppStrings.genericError,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AppBackground(
          child: SafeArea(
            // Caps the content width on tablets / desktop.
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.maxContentWidth),
                child: RefreshIndicator(
                  onRefresh: context.read<ProductsCubit>().refresh,
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      return CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: ProductsHeader(
                              productCount: state.products.length,
                              favoriteCount: state.favoriteIds.length,
                              onLogout: widget.onLogout,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: ProductsSearchField(),
                          ),
                          SliverToBoxAdapter(
                            child: CategoryFilterBar(
                              categories: state.categories,
                              selectedCategory: state.selectedCategory,
                              onSelected:
                                  context.read<ProductsCubit>().selectCategory,
                            ),
                          ),
                          ..._buildBody(context, state),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: AppSpacing.xl),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Loading / error / empty / grid - one branch per state, with no
  /// `SizedBox()` fall-through as in the original implementation.
  List<Widget> _buildBody(BuildContext context, ProductsState state) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: context.productColumns,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: context.productAspectRatio,
    );

    switch (state.status) {
      case ProductsStatus.initial:
      case ProductsStatus.loading:
        return <Widget>[
          ProductsSkeleton(itemCount: 6, gridDelegate: gridDelegate),
        ];

      case ProductsStatus.failure:
        // A failed *refresh* keeps the previously loaded list on screen.
        if (state.products.isNotEmpty) {
          return _buildGrid(context, state, gridDelegate);
        }
        return <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppErrorView(
              title: AppStrings.somethingWrongTitle,
              message: state.message ?? AppStrings.genericError,
              onRetry: context.read<ProductsCubit>().loadProducts,
            ),
          ),
        ];

      case ProductsStatus.success:
        if (state.products.isEmpty) {
          return <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyView(
                title: AppStrings.noProductsTitle,
                message: AppStrings.noProductsMessage,
                actionLabel: state.hasActiveFilter ? 'Clear filters' : null,
                onAction: state.hasActiveFilter
                    ? context.read<ProductsCubit>().clearFilters
                    : null,
              ),
            ),
          ];
        }
        return _buildGrid(context, state, gridDelegate);
    }
  }

  List<Widget> _buildGrid(
    BuildContext context,
    ProductsState state,
    SliverGridDelegate gridDelegate,
  ) {
    final cubit = context.read<ProductsCubit>();

    return <Widget>[
      // Thin progress bar while refreshing: the list stays visible.
      if (state.isRefreshing)
        const SliverToBoxAdapter(
          child: LinearProgressIndicator(minHeight: 2),
        ),
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: context.gutter),
        sliver: SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ProductCard(
      
              key: ValueKey<int>(product.id),
              product: product,
              isFavorite: state.isFavorite(product.id),
              onFavoriteToggle: () => cubit.toggleFavorite(product.id),
              onTap: () => context.push(
                Routes.productDetailsPath(product.id),
    
                extra: product,
              ),
              onAddToCart: () => AppToast.success(
                context,
                '${product.title} · ${AppStrings.addedToCart}',
              ),
            );
          },
        ),
      ),
    ];
  }
}
