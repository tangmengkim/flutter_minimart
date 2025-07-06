// import 'package:json_annotation/json_annotation.dart';
// import 'package:ministore/dio/models/sale/sale_item_model.dart';

// part 'sale_model.g.dart';

// @JsonSerializable(explicitToJson: true)
// class Sale {
//   final int id;

//   final List<SaleItem> items;

//   @JsonKey(name: 'payment_method')
//   final String paymentMethod;

//   final double? tax;
//   final double? discount;

//   @JsonKey(name: 'created_at')
//   final String createdAt;

//   Sale({
//     required this.id,
//     required this.items,
//     required this.paymentMethod,
//     this.tax,
//     this.discount,
//     required this.createdAt,
//   });

//   factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
//   Map<String, dynamic> toJson() => _$SaleToJson(this);
// }
