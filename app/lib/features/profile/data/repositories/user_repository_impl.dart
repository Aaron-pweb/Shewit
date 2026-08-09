import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/app_exception.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final DioClient _dioClient;

  UserRepositoryImpl(this._dioClient);

  @override
  Future<User> getUser(int id) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.users}/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw AppException.network();
      }
      throw AppException.server();
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }
}
