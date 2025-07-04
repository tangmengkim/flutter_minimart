import 'package:dio/dio.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/product_model.dart';
import 'package:ministore/dio/models/product_resp_model.dart';
import 'package:retrofit/retrofit.dart';

part 'product_service.g.dart';

@RestApi()
abstract class ProductService {
  factory ProductService({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ProductService(dio, baseUrl: baseUrl ?? BaseDio.baseUrl);
  }

  // List products with optional filters
  @GET("/products")
  Future<ProductResponse> getProducts({
    @Query("search") String? search,
    @Query("category_id") String? categoryId,
    @Query("section_id") String? sectionId,
    @Query("low_stock") bool? lowStock,
    @Query("per_page") int? perPage,
    @Query("page") int? page,
  });

  // Get product details by ID
  @GET("/products/{id}")
  Future<Product> getProduct(@Path("id") String id);

  @GET("/products")
  Future<ProductResponse> getProductsPaginated(@Query("page") int page);

  // Scan product by barcode
  @GET("/products/barcode/scan")
  Future<Product> scanProductByBarcode(@Query("barcode") String barcode);

  // Create new product (shop_owner)
  @POST("/products")
  Future<Product> createProduct(@Body() Product body);

  // Update product (shop_owner)
  @PUT("/products/{id}")
  Future<Product> updateProduct(
    @Path("id") String id,
    @Body() Product body,
  );

  // Delete product (shop_owner)
  @DELETE("/products/{id}")
  Future<void> deleteProduct(@Path("id") String id);

  // Get low stock products (auth required)
  @GET("/products/alerts/low-stock")
  Future<ProductResponse> getLowStockProducts();
}
