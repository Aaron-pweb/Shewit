import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage;
  
  static const String _tokenKey = 'auth_token';

  AuthRepositoryImpl(this._dioClient, this._secureStorage);

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
      
      // Save token securely
      await _secureStorage.write(key: _tokenKey, value: token);
      
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
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<AuthSession?> checkSession() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        return AuthSession(token: token);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
