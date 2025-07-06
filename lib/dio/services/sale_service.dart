import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/sale/sale_model.dart';
import 'package:ministore/dio/models/sale/sale_req_model.dart';
import 'package:ministore/dio/models/sale/sale_resp_model.dart';
import 'package:ministore/dio/models/sale/sale_summary_model.dart';
import 'package:ministore/dio/models/invoice_model.dart';
import 'package:retrofit/retrofit.dart';

part 'sale_service.g.dart';

@RestApi()
abstract class SaleService {
  factory SaleService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SaleService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  @POST("/sales")
  Future<SaleResp> createSale(@Body() SaleRequest body);

  // Add the new method for invoice response
  @POST("/sales")
  Future<InvoiceResponse> createSaleForInvoice(@Body() SaleRequest body);

  @GET("/sales")
  Future<List<Sale>> getSales({
    @Query("start_date") String? startDate,
    @Query("end_date") String? endDate,
    @Query("today") bool? today,
    @Query("cashier_id") String? cashierId,
  });

  @GET("/sales/{id}")
  Future<Sale> getSaleDetail(@Path("id") String id);

  // Add method to get invoice by ID
  @GET("/sales/{id}")
  Future<InvoiceResponse> getInvoiceById(@Path("id") String id);

  @GET("/sales/summary/daily")
  Future<SaleSummary> getDailySummary({
    @Query("date") String? date,
  });
}
