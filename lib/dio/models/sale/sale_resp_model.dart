import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/sale/sale_model.dart';

part 'sale_resp_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SaleResp {
  final bool success;
  final String? message;
  final Sale data;

  SaleResp({
    required this.success,
    this.message,
    required this.data,
  });

  factory SaleResp.fromJson(Map<String, dynamic> json) =>
      _$SaleRespFromJson(json);
  Map<String, dynamic> toJson() => _$SaleRespToJson(this);
}
