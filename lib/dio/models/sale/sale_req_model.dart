import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/sale/sale_item_model.dart';

part 'sale_req_model.g.dart';

@JsonSerializable()
class SaleRequest {
  final List<SaleItem> items;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  final double? tax;
  final double? discount;

  SaleRequest({
    required this.items,
    required this.paymentMethod,
    this.tax,
    this.discount,
  });

  factory SaleRequest.fromJson(Map<String, dynamic> json) => _$SaleRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SaleRequestToJson(this);
}
