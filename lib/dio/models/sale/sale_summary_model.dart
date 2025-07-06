import 'package:json_annotation/json_annotation.dart';

part 'sale_summary_model.g.dart';

@JsonSerializable()
class SaleSummary {
  final String date;
  final int totalSales;
  final double totalAmount;

  SaleSummary({
    required this.date,
    required this.totalSales,
    required this.totalAmount,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) => _$SaleSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SaleSummaryToJson(this);
}
