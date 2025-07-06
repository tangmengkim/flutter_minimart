import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/product_model.dart';
part 'sale_item_model.g.dart';

// Custom converter for string to double
class StringToDoubleConverter implements JsonConverter<double?, String?> {
  const StringToDoubleConverter();

  @override
  double? fromJson(String? json) {
    if (json == null) return null;
    return double.tryParse(json);
  }

  @override
  String? toJson(double? object) {
    return object?.toString();
  }
}

@JsonSerializable(explicitToJson: true)
class SaleItem {
  final int? id;
  @JsonKey(name: 'product_id')
  final int productId;
  final int quantity;

  // Add StringToDoubleConverter to these fields
  @JsonKey(name: 'unit_price')
  @StringToDoubleConverter()
  final double? unitPrice;

  @JsonKey(name: 'total_price')
  @StringToDoubleConverter()
  final double? totalPrice;

  // For response from API
  final Product? product;

  SaleItem({
    this.id,
    required this.productId,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.product,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}
