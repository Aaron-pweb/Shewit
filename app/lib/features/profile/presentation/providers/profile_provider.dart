import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/models/user_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UserRepositoryImpl(dio);
});

final profileProvider = FutureProvider<User>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  // FakeStore API login doesn't return user ID, so we mock fetching User #1 for the profile view
  return repo.getUser(1);
});
