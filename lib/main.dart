import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/app/app.dart';
import 'package:store_app/core/network/dio_factory.dart';
import 'package:store_app/core/session/session_store.dart';
import 'package:store_app/features/home/data/datasources/products_remote_data_source.dart';
import 'package:store_app/features/home/data/repo/products_repository_impl.dart';
import 'package:store_app/features/home/domain/repositories/products_repository.dart';
import 'package:store_app/features/login/data/datasources/auth_local_data_source.dart';
import 'package:store_app/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:store_app/features/login/data/repo/auth_repository_impl.dart';
import 'package:store_app/features/login/domain/repositories/auth_repository.dart';

/// Composition root: the only place that knows about concrete
/// implementations. Everything below receives its dependencies through
/// constructors.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // --- Dependencies ----------------------------------------------------------
  final preferences = await SharedPreferences.getInstance();
  final dio = DioFactory.create();

  final sessionStore = SessionStore();
  final AuthRepository authRepository = AuthRepositoryImpl(
    remote: AuthRemoteDataSourceImpl(dio),
    local: AuthLocalDataSourceImpl(preferences),
    session: sessionStore,
  );
  final ProductsRepository productsRepository = ProductsRepositoryImpl(
    remote: ProductsRemoteDataSourceImpl(dio),
  );

  // Restore the previous session *before* the first frame, otherwise a logged
  // in user briefly sees the login screen on every cold start.
  await authRepository.restoreSession();

  runApp(
    StoreApp(
      sessionStore: sessionStore,
      authRepository: authRepository,
      productsRepository: productsRepository,
    ),
  );
}
