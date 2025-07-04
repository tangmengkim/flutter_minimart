import 'package:json_annotation/json_annotation.dart';

part 'pagination_link_model.g.dart';

@JsonSerializable()
class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationLinkToJson(this);
}
