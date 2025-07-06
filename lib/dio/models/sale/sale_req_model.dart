import 'package:json_annotation/json_annotation.dart';

part 'sale_req_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SaleRequest {
  final List<SaleRequestItem> items;

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

  factory SaleRequest.fromJson(Map<String, dynamic> json) =>
      _$SaleRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SaleRequestToJson(this);
}

@JsonSerializable()
class SaleRequestItem {
  @JsonKey(name: 'product_id')
  final int productId;

  final int quantity;

  SaleRequestItem({
    required this.productId,
    required this.quantity,
  });

  factory SaleRequestItem.fromJson(Map<String, dynamic> json) =>
      _$SaleRequestItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaleRequestItemToJson(this);
}
