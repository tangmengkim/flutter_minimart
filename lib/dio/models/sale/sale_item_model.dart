import 'package:json_annotation/json_annotation.dart';

part 'sale_item_model.g.dart';

@JsonSerializable()
class SaleItem {
  @JsonKey(name: 'product_id')
  final int productId;

  final int quantity;

  SaleItem({
    required this.productId,
    required this.quantity,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);
  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}
