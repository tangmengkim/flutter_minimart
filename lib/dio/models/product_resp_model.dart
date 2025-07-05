import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/filter_model.dart';
import 'package:ministore/dio/models/pagination_model.dart';
import 'package:ministore/dio/models/product_model.dart';

part 'product_resp_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ListProductResponse {
  final bool success;
  final String message;
  final PaginationData data;

  @JsonKey(name: 'filters_applied')
  final FiltersApplied filtersApplied;

  ListProductResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.filtersApplied,
  });

  factory ListProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ListProductResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListProductResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductResponse {
  final bool success;
  final String message;
  final Product data;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}
