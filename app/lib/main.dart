import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/profile/presentation/providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Initialize Hive
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<String>('shewit_cart');
  final authBox = await Hive.openBox<String>('shewit_auth');
  final wishlistBox = await Hive.openBox<String>('shewit_wishlist');
  final settingsBox = await Hive.openBox<String>('shewit_settings');

  runApp(
    ProviderScope(
      overrides: [
        cartBoxProvider.overrideWithValue(cartBox),
        authBoxProvider.overrideWithValue(authBox),
        wishlistBoxProvider.overrideWithValue(wishlistBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const ShewitApp(),
    ),
  );
}

class ShewitApp extends ConsumerWidget {
  const ShewitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Shewit',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
