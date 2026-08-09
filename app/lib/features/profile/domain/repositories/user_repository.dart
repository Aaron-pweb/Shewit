import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<User> getUser(int id);
}
