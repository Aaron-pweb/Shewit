import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/app_exception.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _dioClient;

  ProductRepositoryImpl(this._dioClient);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.products);
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.products}/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.categories);
      final List<dynamic> data = response.data;
      return data.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.categoryProducts}/$category');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException.unknown(e.toString());
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return AppException.network();
    }
    if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
      return AppException.server();
    }
    return AppException.unknown(e.message);
  }
}
