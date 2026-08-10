import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/network/dio_client.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Provide dependencies
final dioClientProvider = Provider<DioClient>((ref) => DioClient());
final authBoxProvider = Provider<Box<String>>((ref) => throw UnimplementedError());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final authBox = ref.watch(authBoxProvider);
  return AuthRepositoryImpl(dio, authBox);
});

// Auth State Provider
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    state = const AsyncValue.loading();
    try {
      // Artificial delay to ensure Splash Screen is visible for at least 1.5 seconds
      await Future.delayed(const Duration(milliseconds: 1500));
      final session = await _repository.checkSession();
      state = AsyncValue.data(session != null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repository.login(username, password);
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
      state = const AsyncValue.data(false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
