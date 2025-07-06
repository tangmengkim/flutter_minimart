import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/sale/sale_req_model.dart';
import 'package:ministore/dio/models/sale/sale_resp_model.dart';
import 'package:ministore/dio/models/sale/sale_summary_model.dart';
import 'package:retrofit/retrofit.dart';

part 'sale_service.g.dart';

@RestApi()
abstract class SaleService {
  factory SaleService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SaleService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  @POST("/api/v1/sales")
  Future<SaleResp> createSale(@Body() SaleRequest body);

  @GET("/api/v1/sales")
  Future<List<Sale>> getSales({
    @Query("start_date") String? startDate,
    @Query("end_date") String? endDate,
    @Query("today") bool? today,
    @Query("cashier_id") String? cashierId,
  });

  @GET("/api/v1/sales/{id}")
  Future<Sale> getSaleDetail(@Path("id") String id);

  @GET("/api/v1/sales/summary/daily")
  Future<SaleSummary> getDailySummary({
    @Query("date") String? date,
  });
}
