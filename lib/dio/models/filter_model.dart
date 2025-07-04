import 'package:json_annotation/json_annotation.dart';

part 'filter_model.g.dart';

@JsonSerializable()
class FiltersApplied {
  final String? search;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  @JsonKey(name: 'section_id')
  final int? sectionId;

  @JsonKey(name: 'low_stock')
  final bool? lowStock;

  FiltersApplied({
    this.search,
    this.categoryId,
    this.sectionId,
    this.lowStock,
  });

  factory FiltersApplied.fromJson(Map<String, dynamic> json) =>
      _$FiltersAppliedFromJson(json);
  Map<String, dynamic> toJson() => _$FiltersAppliedToJson(this);
}
