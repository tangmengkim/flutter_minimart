import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';
import 'pagination_link_model.dart';

part 'pagination_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginationData {
  @JsonKey(name: 'current_page')
  final int currentPage;

  final List<Product> data;

  @JsonKey(name: 'first_page_url')
  final String firstPageUrl;

  final int from;

  @JsonKey(name: 'last_page')
  final int lastPage;

  @JsonKey(name: 'last_page_url')
  final String lastPageUrl;

  final List<PaginationLink> links;

  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;

  final String path;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;

  final int to;
  final int total;

  PaginationData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) =>
      _$PaginationDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationDataToJson(this);
}
