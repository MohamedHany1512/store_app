import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/constants/app_strings.dart';
import 'package:store_app/core/routing/app_router.dart';
import 'package:store_app/core/session/session_scope.dart';
import 'package:store_app/core/session/session_store.dart';
import 'package:store_app/core/theme/app_theme.dart';
import 'package:store_app/features/home/domain/repositories/products_repository.dart';
import 'package:store_app/features/home/domain/usecases/get_products.dart';
import 'package:store_app/features/home/presentation/cubit/products_cubit.dart';
import 'package:store_app/features/login/domain/repositories/auth_repository.dart';
import 'package:store_app/features/login/domain/usecases/login_user.dart';
import 'package:store_app/features/login/presentation/cubit/login_cubit.dart';
 
class StoreApp extends StatefulWidget {
  const StoreApp({
    required this.sessionStore,
    required this.authRepository,
    required this.productsRepository,
    super.key,
  });

  final SessionStore sessionStore;
  final AuthRepository authRepository;
  final ProductsRepository productsRepository;

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  late final AppRouter _router = AppRouter(sessionStore: widget.sessionStore);

  @override
  void dispose() {
    _router.router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SessionScope(
       notifier: widget.sessionStore,
      child: MultiRepositoryProvider(
        providers: <RepositoryProvider<Object>>[
          RepositoryProvider<AuthRepository>.value(value: widget.authRepository),
          RepositoryProvider<ProductsRepository>.value(
            value: widget.productsRepository,
          ),
        ],
        child: _AppScope(
          child: MaterialApp.router(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: _router.router,
            builder: _buildWithTextScaleGuard,
          ),
        ),
      ),
    );
  }

 
  Widget _buildWithTextScaleGuard(BuildContext context, Widget? child) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 0.85,
      maxScaleFactor: 1.3,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

 
class _AppScope extends StatelessWidget {
  const _AppScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
            loginUser: LoginUser(context.read<AuthRepository>()),
          ),
        ),
        BlocProvider<ProductsCubit>(
     
          create: (context) => ProductsCubit(
            getProducts: GetProducts(context.read<ProductsRepository>()),
          ),
        ),
      ],
      child: child,
    );
  }
}
