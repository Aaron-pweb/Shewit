import 'package:freezed_annotation/freezed_annotation.dart';
import 'rating_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String title,
    required num price,
    required String description,
    required String category,
    required String image,
    required Rating rating,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
