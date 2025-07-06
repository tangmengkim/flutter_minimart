import 'package:json_annotation/json_annotation.dart';

part 'invoice_model.g.dart';

// Custom converter for string to double
class StringToDoubleConverter implements JsonConverter<double, String> {
  const StringToDoubleConverter();

  @override
  double fromJson(String json) {
    return double.parse(json);
  }

  @override
  String toJson(double object) {
    return object.toString();
  }
}

// Response wrapper for the API response
@JsonSerializable(explicitToJson: true)
class InvoiceResponse {
  final bool success;
  final String message;
  final Invoice data;

  InvoiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);
}

// Main Invoice model
@JsonSerializable(explicitToJson: true)
class Invoice {
  final int id;

  @JsonKey(name: 'cashier_id')
  final int cashierId;

  @StringToDoubleConverter()
  final double subtotal;

  @StringToDoubleConverter()
  final double tax;

  @StringToDoubleConverter()
  final double discount;

  @StringToDoubleConverter()
  final double total;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'sale_date')
  final String saleDate;

  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final List<InvoiceItem> items;
  final Cashier? cashier;

  Invoice({
    required this.id,
    required this.cashierId,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.saleDate,
    required this.invoiceNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.cashier,
  });

  // Computed property for formatted invoice number
  String get displayInvoiceNumber => invoiceNumber;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}

// Invoice Item model
@JsonSerializable(explicitToJson: true)
class InvoiceItem {
  final int id;

  @JsonKey(name: 'sale_id')
  final int saleId;

  @JsonKey(name: 'product_id')
  final int productId;

  final int quantity;

  @JsonKey(name: 'unit_price')
  @StringToDoubleConverter()
  final double unitPrice;

  @JsonKey(name: 'total_price')
  @StringToDoubleConverter()
  final double totalPrice;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final InvoiceProduct? product;

  InvoiceItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}

// Product model for invoice
@JsonSerializable(explicitToJson: true)
class InvoiceProduct {
  final int id;
  final String name;
  final String? barcode;
  final String? description;

  @StringToDoubleConverter()
  final double price;

  @JsonKey(name: 'cost_price')
  @StringToDoubleConverter()
  final double? costPrice;

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
  final bool isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'full_image_url')
  final String? fullImageUrl;

  InvoiceProduct({
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
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.imageUrl,
    this.fullImageUrl,
  });

  factory InvoiceProduct.fromJson(Map<String, dynamic> json) =>
      _$InvoiceProductFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceProductToJson(this);
}

// Cashier model for invoice
@JsonSerializable(explicitToJson: true)
class Cashier {
  final int id;
  final String name;
  final String email;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  final String role;
  final String? phone;

  @JsonKey(name: 'shop_owner_id')
  final int shopOwnerId;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  Cashier({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    this.phone,
    required this.shopOwnerId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Cashier.fromJson(Map<String, dynamic> json) =>
      _$CashierFromJson(json);

  Map<String, dynamic> toJson() => _$CashierToJson(this);
}
