import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'sale_model.g.dart';

@JsonSerializable()
class SaleItem {
  final Product product;
  final int quantity;
  final double price;

  SaleItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}

@JsonSerializable()
class SaleModel {
  final List<SaleItem> items;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  final double? tax;
  final double? discount;

  SaleModel({
    required this.items,
    required this.paymentMethod,
    this.tax,
    this.discount,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleModelToJson(this);
}
