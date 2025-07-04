import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';
import 'section_model.dart';
import 'shelf_model.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  final int? id;
  final String name;
  final String? barcode;
  final String? description;
  final String price;

  @JsonKey(name: 'cost_price')
  final String? costPrice;

  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;

  @JsonKey(name: 'min_stock_level')
  final int minStockLevel;

  final String? image;

  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'section_id')
  final int sectionId;

  @JsonKey(name: 'shelf_id')
  final int shelfId;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'is_low_stock')
  final bool? isLowStock;

  @JsonKey(name: 'is_out_of_stock')
  final bool? isOutOfStock;

  @JsonKey(name: 'location_full')
  final String? locationFull;

  @JsonKey(name: 'full_image_url')
  final String? imageUrl;

  final Category? category;
  final Section? section;
  final Shelf? shelf;

  Product({
    required this.id,
    required this.name,
    this.barcode,
    this.description,
    required this.price,
    this.costPrice,
    required this.stockQuantity,
    required this.minStockLevel,
    this.image,
    required this.categoryId,
    required this.sectionId,
    required this.shelfId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isLowStock,
    this.isOutOfStock,
    this.locationFull,
    this.imageUrl,
    this.category,
    this.section,
    this.shelf,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
