import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/cart/presentation/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<String>('shewit_cart');
  
  runApp(
    ProviderScope(
      overrides: [
        cartBoxProvider.overrideWithValue(cartBox),
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

    return MaterialApp.router(
      title: 'Shewit',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
