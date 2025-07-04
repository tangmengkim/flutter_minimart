import 'package:json_annotation/json_annotation.dart';

part 'section_model.g.dart';

@JsonSerializable()
class Section {
  final int id;
  final String name;
  final String description;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  Section({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}

@JsonSerializable()
class SectionListResp {
  @JsonKey(name: "success")
  final bool isSuccess;

  @JsonKey(name: "data")
  final List<Section> sections;

  SectionListResp({required this.isSuccess, required this.sections});

  factory SectionListResp.fromJson(Map<String, dynamic> json) =>
      _$SectionListRespFromJson(json);

  Map<String, dynamic> toJson() => _$SectionListRespToJson(this);
}
