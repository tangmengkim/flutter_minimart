import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/category_model.dart';

part 'category_resp_model.g.dart';

@JsonSerializable()
class CategoryListResp {
  @JsonKey(name: "success")
  final bool isSuccess;

  @JsonKey(name: "data")
  final List<Category> categories;

  CategoryListResp({required this.isSuccess, required this.categories});

  factory CategoryListResp.fromJson(Map<String, dynamic> json) =>
      _$CategoryListRespFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListRespToJson(this);
}
