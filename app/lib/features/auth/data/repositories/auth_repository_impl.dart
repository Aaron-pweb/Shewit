import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final Box<String> _authBox;
  
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl(this._dioClient, this._authBox);

  @override
  Future<AuthSession> login(String username, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      
      final token = response.data['token'] as String;
      
      // Save token safely using Hive instead of flutter_secure_storage (which hangs on Linux)
      await _authBox.put(_tokenKey, token);
      
      return AuthSession(token: token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AppException.unauthorized();
      }
      throw AppException.network();
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _authBox.delete(_tokenKey);
  }

  @override
  Future<AuthSession?> checkSession() async {
    try {
      final token = _authBox.get(_tokenKey);
      if (token != null && token.isNotEmpty) {
        return AuthSession(token: token);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
