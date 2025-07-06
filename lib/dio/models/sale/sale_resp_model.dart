import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/dio/models/product_model.dart';

part 'sale_resp_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SaleResp {
  final bool success;
  final String message;
  final Sale data;

  SaleResp({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SaleResp.fromJson(Map<String, dynamic> json) =>
      _$SaleRespFromJson(json);

  Map<String, dynamic> toJson() => _$SaleRespToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Sale {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'cashier_id')
  final int cashierId;

  final String subtotal;
  final String? tax;
  final String? discount;
  final String total;

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

  final List<SaleItemDetail> items;
  final User cashier;

  Sale({
    required this.id,
    required this.cashierId,
    required this.subtotal,
    this.tax,
    this.discount,
    required this.total,
    required this.paymentMethod,
    required this.saleDate,
    required this.invoiceNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.cashier,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
  Map<String, dynamic> toJson() => _$SaleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaleItemDetail {
  final int id;

  @JsonKey(name: 'sale_id')
  final int saleId;

  @JsonKey(name: 'product_id')
  final int productId;

  final int quantity;

  @JsonKey(name: 'unit_price')
  final String unitPrice;

  @JsonKey(name: 'total_price')
  final String totalPrice;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final Product product;

  SaleItemDetail({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory SaleItemDetail.fromJson(Map<String, dynamic> json) =>
      _$SaleItemDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SaleItemDetailToJson(this);
}
