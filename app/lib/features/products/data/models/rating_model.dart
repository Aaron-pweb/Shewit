import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
class Rating with _$Rating {
  const factory Rating({
    @JsonKey(name: 'rate') required num rate,
    @JsonKey(name: 'count') required int count,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}
