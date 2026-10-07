import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/core/constants/app_durations.dart';
import 'package:store_app/core/constants/app_spacing.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/routing/routes.dart';
import 'package:store_app/core/session/session_store.dart';
import 'package:store_app/core/widgets/app_button.dart';
import 'package:store_app/core/widgets/state_views.dart';
import 'package:store_app/features/home/domain/entities/product.dart';
 
import 'package:store_app/features/home/presentation/cubit/products_cubit.dart';
import 'package:store_app/features/home/presentation/pages/product_details_page.dart';
import 'package:store_app/features/home/presentation/pages/products_page.dart';
import 'package:store_app/features/login/domain/repositories/auth_repository.dart';
import 'package:store_app/features/login/presentation/views/login_screen.dart';

 
class AppRouter {
  AppRouter({required SessionStore sessionStore}) : _sessionStore = sessionStore;

  final SessionStore _sessionStore;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.login,
    debugLogDiagnostics: kDebugMode,
    // Any auth change re-runs `redirect` automatically.
    refreshListenable: _sessionStore,
    redirect: _redirect,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        pageBuilder: (context, state) => _fadePage<void>(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        name: Routes.homeName,
        builder: (context, state) => ProductsPage(
          onLogout: () => _logout(context),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: Routes.productDetails,
            name: Routes.productDetailsName,
            pageBuilder: (context, state) => _slidePage<void>(
              state: state,
              child: ProductDetailsPage(
                product: _resolveProduct(context, state),
              ),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => _fadePage<void>(
      state: state,
      child: const _RouteNotFoundPage(),
    ),
  );

  /// Guests can only reach the login page, logged-in users never see it again.
  String? _redirect(BuildContext context, GoRouterState state) {
    final isAtLogin = state.matchedLocation == Routes.login;
    final isAuthenticated = _sessionStore.isAuthenticated;

    if (!isAuthenticated) {
      return isAtLogin ? null : Routes.login;
    }
    return isAtLogin ? Routes.home : null;
  }

  /// Resolves the product for the details page.
  ///
  /// 1. Normal navigation: the card passes the product through `extra`, so the
  ///    page can render instantly (and the Hero matches).
  /// 2. Deep link (`/home/product/5`): there is no `extra`, so the product is
  ///    looked up in the catalog held by [ProductsCubit]. This works because
  ///    the Cubit is provided **above** the router - a route-level provider
  ///    would not be reachable from the child route's builder.
  Product? _resolveProduct(BuildContext context, GoRouterState state) {
    final extra = state.extra;
    if (extra is Product) {
      return extra;
    }

    final id = Routes.parseProductId(state.pathParameters['productId']);
    if (id == null) {
      return null;
    }

    for (final product in context.read<ProductsCubit>().state.products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  /// Logging out only clears the session - [SessionStore] then notifies the
  /// router, whose redirect sends the user back to the login page.
  void _logout(BuildContext context) {
    unawaited(context.read<AuthRepository>().logout());
  }

  // --- Transitions -----------------------------------------------------------
  static CustomTransitionPage<T> _fadePage<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppDurations.normal,
      reverseTransitionDuration: AppDurations.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: AppDurations.standard,
          ),
          child: child,
        );
      },
    );
  }

  /// Subtle slide + fade, direction aware for RTL locales.
  static CustomTransitionPage<T> _slidePage<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppDurations.normal,
      reverseTransitionDuration: AppDurations.fast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppDurations.emphasized,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(isRtl ? -0.12 : 0.12, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }
}

class _RouteNotFoundPage extends StatelessWidget {
  const _RouteNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppEmptyView(
              title: AppStrings.pageNotFound,
              message: AppStrings.genericError,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: AppButton(
                label: AppStrings.goBackHome,
                expand: false,
                onPressed: () => context.go(Routes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}