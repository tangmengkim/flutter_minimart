import 'package:json_annotation/json_annotation.dart';

part 'shelf_model.g.dart';

@JsonSerializable()
class Shelf {
  final int id;
  final String name;
  final String description;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  Shelf({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);
  Map<String, dynamic> toJson() => _$ShelfToJson(this);
}

@JsonSerializable()
class ShelfListResp {
  @JsonKey(name: "success")
  final bool isSuccess;

  @JsonKey(name: "data")
  final List<Shelf> shelfs;

  ShelfListResp({required this.isSuccess, required this.shelfs});

  factory ShelfListResp.fromJson(Map<String, dynamic> json) =>
      _$ShelfListRespFromJson(json);

  Map<String, dynamic> toJson() => _$ShelfListRespToJson(this);
}
