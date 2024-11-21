import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/provider/auth/auth_provider.dart';
import '../../presentation/presentations.dart';
import '../../config/router/app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
          path: '/product/:id', // /product/new
          builder: (context, state) {
            return ProductScreen(
              productId: state.params['id'] ?? 'no-id',
            );
          }),
    ],
    redirect: (context, state) {
      final comesFrom = state.subloc;

//--> call final goRouterNotifier that is conect with goRouterNotifierProvider this provider class have a property type of AuthNotifier
//--> when call this provider is run the function that checkAuth status
//--> when the state of this provider change, goRouterNotifierProvider listen the new state that we will have on final authStatus
      final authStatus = goRouterNotifier.authStatus;

      if (comesFrom == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (comesFrom == '/login' || comesFrom == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (comesFrom == '/login' ||
            comesFrom == '/register' ||
            comesFrom == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
