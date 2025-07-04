import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/section_model.dart';

part 'shelve_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Shelve {
  final int id;
  final String name;
  @JsonKey(name: 'section_id')
  final int sectionId;
  final int level;
  final String description;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final Section section;
  final List<Product> products;

  Shelve({
    required this.id,
    required this.name,
    required this.sectionId,
    required this.level,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.section,
    required this.products,
  });

  factory Shelve.fromJson(Map<String, dynamic> json) => _$ShelveFromJson(json);
  Map<String, dynamic> toJson() => _$ShelveToJson(this);
}
