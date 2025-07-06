import 'package:json_annotation/json_annotation.dart';
import 'package:ministore/dio/models/sale/sale_item_model.dart';
part 'sale_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Sale {
  final int id;
  final List<SaleItem> items;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @StringToDoubleConverter()
  final double subtotal;

  @StringToDoubleConverter()
  final double total;

  @StringToDoubleConverter()
  final double? tax;

  @StringToDoubleConverter()
  final double? discount;

  @JsonKey(name: 'sale_date')
  final String saleDate;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'invoice_number')
  final String? invoiceNumber;

  // Add cashier information if needed
  final Map<String, dynamic>? cashier;

  Sale({
    required this.id,
    required this.items,
    required this.paymentMethod,
    required this.subtotal,
    required this.total,
    this.tax,
    this.discount,
    required this.saleDate,
    required this.createdAt,
    this.invoiceNumber,
    this.cashier,
  });

  // Computed property for invoice number fallback
  String get displayInvoiceNumber =>
      invoiceNumber ?? 'INV-${id.toString().padLeft(6, '0')}';

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}
