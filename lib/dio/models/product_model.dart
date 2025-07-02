import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final String name;
  final double price;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(name: 'section_id')
  final int sectionId;
  @JsonKey(name: 'shelf_id')
  final int shelfId;
  final String? barcode;
  final String? description;
  @JsonKey(name: 'cost_price')
  final double? costPrice;
  @JsonKey(name: 'min_stock_level')
  final int? minStockLevel;
  final String? image;

  Product({
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    required this.sectionId,
    required this.shelfId,
    this.barcode,
    this.description,
    this.costPrice,
    this.minStockLevel,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
