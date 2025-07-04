import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/filter_model.dart';
import 'package:ministore/dio/models/pagination_model.dart';

part 'product_resp_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductResponse {
  final bool success;
  final String message;
  final PaginationData data;

  @JsonKey(name: 'filters_applied')
  final FiltersApplied filtersApplied;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.filtersApplied,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}
